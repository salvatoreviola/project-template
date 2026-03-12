from pathlib import Path

def get_project_root():
    current_path = Path(__file__).resolve()
    for parent in current_path.parents:
        if (parent / "src").is_dir() and (parent / "data").is_dir():
            return parent
    raise RuntimeError("Project root not found.")

# Set paths relative to the project root
MAIN_PATH = get_project_root()
DATA_PATH = MAIN_PATH / "data"
CODE_PATH = MAIN_PATH / "src"
OUTPUT_PATH = MAIN_PATH / "output"