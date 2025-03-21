from datetime import datetime
from datetime import timedelta
from pathlib import Path

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from dbt_airflow.core.config import DbtAirflowConfig
from dbt_airflow.core.config import DbtProfileConfig
from dbt_airflow.core.config import DbtProjectConfig
from dbt_airflow.core.task_group import DbtTaskGroup
from dbt_airflow.operators.execution import ExecutionOperator


with DAG(
    dag_id='test_dag_without_extras',
    start_date=datetime(2021, 1, 1),
    catchup=False,
    tags=['example'],
    default_args={
        'owner': 'airflow',
        'retries': 1,
        'retry_delay': timedelta(minutes=2),
    },

) as dag:

    t1 = EmptyOperator(task_id='extract')
    t2 = EmptyOperator(task_id='load')


    tg = DbtTaskGroup(
        group_id='transform',
        dbt_project_config=DbtProjectConfig(
            project_path=Path('/opt/airflow/example_dbt_project/'),
            manifest_path=Path('/opt/airflow/example_dbt_project/target/manifest.json'),
        ),
        dbt_profile_config=DbtProfileConfig(
            profiles_path=Path('/opt/airflow/example_dbt_project/profiles'),
            target='dev',
        ),
        dbt_airflow_config=DbtAirflowConfig(
            execution_operator=ExecutionOperator.BASH,
        ),
    )

    t1 >> t2 >> tg
