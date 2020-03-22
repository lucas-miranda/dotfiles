import math, re, subprocess
from datetime import datetime
from libqtile import bar
from libqtile.widget import base


def min(a, b):
    if a < b:
        return a
    return b

def max(a, b):
    if a > b:
        return a
    return b

def clamp(value, minimum, maximum):
    return max(min(value, maximum), minimum)


class Audio(base._TextBox):
    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ('volume_strategy', 'flat', 'Which strategy to modify volume, it can be: \'flat\' or \'incremental\'.'),
        ('update_interval', 0.2, 'Update interval in seconds')
    ]

    def __init__(self, **config) -> None:
        base._TextBox.__init__(self, "Audio", bar.CALCULATED, **config)
        self.name = "audio"
        self.add_defaults(self.defaults)

        # volume
        self.volume_regex = re.compile('(\d+)%')
        self.volume = None
        self.volume_base_modify_value = 2

        ## incremental strategy
        self.volume_incremental = 0
        self.volume_max_incremental = self.volume_base_modify_value * 5
        self.volume_last_modify_datetime = None

    def timer_setup(self):
        self.timeout_add(self.update_interval, self.update)

    def update(self):
        mixer_volume = self._get_mixer_volume("Master")
        if self.volume != mixer_volume:
            self.volume = mixer_volume
            self.text = '{}% ({})'.format(self.volume, self.volume_incremental)
            self.bar.draw()

        self.timeout_add(self.update_interval, self.update)

    def draw(self):
        base._TextBox.draw(self)

    def volume_increase(self):
        self._update_volume_incremental(1)

        if self.volume_incremental == 0:
            return

        current_volume = self._get_mixer_volume('Master')
        volume_modify = min(100 - current_volume, self.volume_incremental)
        volume_modify = volume_modify * 65.0 / 100.0

        if volume_modify <= 0:
            return;

        self.call_process(['amixer', '--card', '0', '--quiet', 'set', 'Master', '%ddB+' % volume_modify])

    def volume_decrease(self):
        self._update_volume_incremental(-1)

        if self.volume_incremental == 0:
            return

        current_volume = self._get_mixer_volume('Master')
        volume_modify = min(current_volume, math.fabs(self.volume_incremental))
        volume_modify = volume_modify * 65.0 / 100.0

        self.call_process(['amixer', '--card', '0', '--quiet', 'set', 'Master', '%ddB-' % volume_modify])

    def _get_mixer_volume(self, mixerID):
        mixer_ret = self.call_process(["amixer", "get", mixerID])

        volume = 0
        for match in self.volume_regex.finditer(mixer_ret):
            volume_value_group = match[1]
            v = int(volume_value_group)
            if v > volume:
                volume = v

        return volume

    def _update_volume_incremental(self, operation):
        if self.volume_incremental == 0 or self.volume_last_modify_datetime == None or math.copysign(1, self.volume_incremental) != operation:
            self.volume_incremental = self.volume_base_modify_value * operation
        else:
            time_since_last_usage = datetime.now() - self.volume_last_modify_datetime

            if time_since_last_usage.seconds > 1:
                self.volume_incremental = self.volume_base_modify_value * operation
            else:
                self.volume_incremental = clamp(self.volume_incremental * 2, -self.volume_max_incremental, self.volume_max_incremental)

        self.volume_last_modify_datetime = datetime.now()

