function build() {
    local build_target=$1
    if [[ -z "$build_target" ]]
    then
        echo "[Error] Missing parameter: build target, supported values are: cs"
        return
    fi

    if [[ "$build_target" == "cs" ]] || [[ "$build_target" == "csharp" ]]
    then
        echo "> Targeting C#"

        local project_file="" build_type="build" configuration="Debug" platform="x86"

        if [[ ! -z $2 ]]
        then
            project_file=$2
        fi

        if [[ ! -z $3 ]]
        then
            build_type=$3
        fi

        if [[ ! -z $4 ]]
        then
            configuration=$4
        fi

        if [[ ! -z $5 ]]
        then
            platform=$5
        fi

        local ret=1

        if [[ "$build_type" == "restore" ]] || [[ "$build_type" == "Restore" ]] || [[ "$build_type" == "clean" ]] || [[ "$build_type" == "Clean" ]]
        then
            echo "  Project File: $project_file"
            echo "  Build Type: $build_type"

            echo "> Running..."

            if [[ -z project_file ]]
            then
                echo "msbuild -t:$build_type"
                echo ""
                msbuild -t:$build_type
                ret=$?
            else
                echo "msbuild \"$project_file\" -t:$build_type"
                echo ""
                msbuild "$project_file" -t:$build_type
                ret=$?
            fi
        else
            echo "  Project File: $project_file"
            echo "  Build Type: $build_type"
            echo "  Configuration: $configuration" 
            echo "  Platform: $platform"

            echo "> Running..."

            if [[ -z project_file ]]
            then
                echo "msbuild -t:$build_type -p:Configuration=$configuration -p:Platform=$platform $extra_args -noLogo -maxCpuCount:4"
                echo ""
                msbuild -t:$build_type -p:Configuration=$configuration -p:Platform=$platform $extra_args -noLogo -maxCpuCount:4
                ret=$?
            else
                echo "msbuild \"$project_file\" -t:$build_type -p:Configuration=$configuration -p:Platform=$platform $extra_args -noLogo -maxCpuCount:4"
                echo ""
                msbuild "$project_file" -t:$build_type -p:Configuration=$configuration -p:Platform=$platform $extra_args -noLogo -maxCpuCount:4
                ret=$?
            fi
        fi

        echo "Done!"
        return $ret
    else
        echo "[Error] Build target: $build_target, not supported. (Accepted values are: cs)"
    fi

    return 1
}
