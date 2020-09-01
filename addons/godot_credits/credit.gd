extends Resource
class_name WorkCredit


export(String) var title := ""
export(Array) var files := []
export(Array, Resource) var licenses := []
# The author of the work (e.g. programmer, artist, by...).
export(Array, Resource) var authors := []
# People or organizations who contributed to the work by comissioning it (i.e. Commissioned by...).
export(Array, Resource) var commissioners := []
# People or organizations who also contributed to the work in some way (i.e. Contributions by...).
export(Array, Resource) var other_contributors := []
export(PoolStringArray) var sources := []
# Will be shown at the end of the credit if show_notes set to true (default).
export(String, MULTILINE) var notes := ""
# Will not be shown in the credits.
export(String, MULTILINE) var additional_notes := ""
export(String, MULTILINE) var license_text := ""

export(Array, Resource) var derived_from := []
