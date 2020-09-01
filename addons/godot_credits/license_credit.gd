extends Resource
class_name License


# Most ids are based on the SPDX ID for the license which can be found here:
# https://spdx.org/licenses/. For licenses not in the SPDX database an id can
# be made up, but should follow a similar format.
export(String) var id := ""
export(String) var full_name := ""
export(bool) var free := true
export(String, MULTILINE) var text := ""
export(String) var url := ""
