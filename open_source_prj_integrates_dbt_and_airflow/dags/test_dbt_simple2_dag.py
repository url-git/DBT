# Define the default arguments for the DAG
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 4, 21),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}
# Create the DAG with the specified schedule interval
dag = DAG('test_dbt_simple2_dag', catchup=False, default_args=default_args, schedule_interval=timedelta(days=1))
# Define dbt tasks using BashOperator
task1 = BashOperator(
    task_id='dbt_task1',
    bash_command='dbt run --models model1 model2',
    dag=dag
)
task2 = BashOperator(
    task_id='dbt_task2',
    bash_command='dbt run --models model3 model4',
    dag=dag
)
# Set task dependencies
task1 >> task2

