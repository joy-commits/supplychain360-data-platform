import pytest
from pathlib import Path
import importlib.util

BASE_DIR = Path(__file__).resolve().parent.parent

def test_requirements_is_valid():
    """Is requirements.txt missing critical libraries?"""
    req_file = BASE_DIR / "requirements.txt"
    assert req_file.exists(), "Missing requirements.txt!"
    
    content = req_file.read_text()
    required_libs = ["apache-airflow", "dbt-snowflake", "pytest"]
    for lib in required_libs:
        assert lib in content, f"{lib} is missing from requirements.txt!"

def test_dag_syntax_check():
    """Does the DAG files actually have valid Python code?"""
    dag_path = BASE_DIR / "airflow" / "dags" / "extract.py"
    assert dag_path.exists(), f"DAG file not found at {dag_path}"
    
    # This 'compiles' the code without running it to check for Syntax Errors
    with open(dag_path) as f:
        try:
            compile(f.read(), dag_path, 'exec')
        except SyntaxError as e:
            pytest.fail(f"Syntax error in {dag_path}: {e}")

def test_dbt_project_config():
    """Is the dbt_project.yml valid YAML?"""
    import yaml # You'll need 'pip install PyYAML'
    dbt_path = BASE_DIR / "airflow" / "dags" / "dbt_transform" / "dbt_project.yml"
    
    with open(dbt_path) as f:
        config = yaml.safe_load(f)
    
    assert config['name'] == 'dbt_transform', "dbt project name mismatch!"
    assert 'profile' in config, "dbt_project.yml is missing a profile definition!"