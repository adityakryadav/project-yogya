import os

screens = [
    "splash_screen.dart", "login_screen.dart", "dashboard_screen.dart",
    "main_layout.dart", "eligibility_engine_screen.dart",
    "eligibility_timeline_screen.dart", "documents_scanner_screen.dart",
    "profile_screen.dart", "settings_screen.dart"
]

os.makedirs("yogya_app/lib/presentation/screens", exist_ok=True)

for sc in screens:
    name = sc.replace(".dart", "").replace("_", " ").title().replace(" ", "")
    content = f"""import 'package:flutter/material.dart';\n\nclass {name} extends StatelessWidget {{\n  const {name}({{super.key}});\n\n  @override\n  Widget build(BuildContext context) {{\n    return const Scaffold(\n      body: Center(child: Text('{name}')),\n    );\n  }}\n}}\n"""
    with open(f"yogya_app/lib/presentation/screens/{sc}", "w", encoding="utf-8") as f:
        f.write(content)
print("Stubs created.")
