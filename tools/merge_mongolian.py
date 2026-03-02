#!/usr/bin/env python3
"""Merge generated Mongolian content into horoscope_content_prewritten.dart"""

import re

prewritten_path = "lib/data/horoscope_content_prewritten.dart"
generated_path = "lib/data/horoscope_mongolian_generated.dart"

with open(prewritten_path, "r", encoding="utf-8") as f:
    prewritten = f.read()

with open(generated_path, "r", encoding="utf-8") as f:
    generated = f.read()

# Extract entries from generated (from first date to end)
lines = generated.strip().split("\n")
start_idx = next(i for i, L in enumerate(lines) if L.strip().startswith("'2026-") and "':" in L)
new_entries = "\n".join(lines[start_idx:]).rstrip()

# Replace the entire block from first '2026-03-01' (or '2026-02-28') through "  };"
# This removes old Mar 1 - May 1 and replaces with Feb 28 - May 2 from generator
pattern = r"(\s+'2026-02-29': _mongolianDay\([^)]+\)\s+\),\s+)(\s+'2026-\d{2}-\d{2}': _mongolianDay\(.*?)^(\s+\};)"
repl = r"\1" + new_entries + r"\n\3"

# Simpler: replace from "    '2026-03-01':" or "    '2026-02-28':" through "  };"
# Match: everything from first new date entry after Feb 29 through the map closing
old_block_pattern = re.compile(
    r"(\s+'2026-02-29': _mongolianDay\(.*?^\s+\),)\s+(\s+'2026-\d{2}-\d{2}':.*?)^(\s+\};)",
    re.MULTILINE | re.DOTALL
)

# Find where the block to replace starts - after Feb 29's closing "),"
feb29_end = prewritten.find("'2026-02-29': _mongolianDay(")
if feb29_end == -1:
    raise SystemExit("Could not find Feb 29 entry")

# Find the closing ")," of Feb 29 - it's the first "    )," after the Feb 29 content
# The structure: '2026-02-29': _mongolianDay( ... 12 lines ... ),
after_feb29 = prewritten[feb29_end:]
# Find "    )," that closes Feb 29 - it appears after the 12 string lines
close_idx = after_feb29.find("    ),")
if close_idx == -1:
    raise SystemExit("Could not find Feb 29 closing")
feb29_block_end = feb29_end + close_idx + len("    ),")

# Everything from feb29_block_end to end of _content map - we keep Feb 29, replace the rest
rest = prewritten[feb29_block_end:]
# Find "  };"
map_end = rest.find("  };")
if map_end == -1:
    raise SystemExit("Could not find map end")

# The part to replace is from after Feb 29's ")," through "  };"
# Keep everything after the map (getBundle, _mongolianDay, _DayContent, etc.)
replacement = "\n" + new_entries + "\n  };"
after_map = rest[map_end + len("  };") :]

new_content = prewritten[:feb29_block_end] + replacement + after_map

with open(prewritten_path, "w", encoding="utf-8") as f:
    f.write(new_content)

print("Merged successfully")
