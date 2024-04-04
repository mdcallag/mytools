# AutoDBA - Vacuum Reinforcement Learning Project

## Overview
This project aims to enhance the PostgreSQL AutoVacuum feature using reinforcement learning (RL) techniques. By integrating a custom RL model with PostgreSQL, we seek to optimize vacuuming decisions dynamically based on database activity, improving performance and resource utilization.

## Components
- `autovac_driver.py`: Main script for the reinforcement learning driver that interacts with the PostgreSQL AutoVacuum feature.
- `iibench_driver.py`: iibench workload to simulate database load and test the RL model's effectiveness.
- `learning/`: Directory containing the reinforcement learning model and training scripts.

## Requirements
- Python 3.8+
- PyTorch
- PostgreSQL

## Installation
Provide step-by-step instructions to set up the project:

1. Clone the repository:
   ```
   git clone https://github.com/crystalcld/mytools
   ```
2. Navigate to the project directory:
   ```
   cd bench/ibench
   ```
3. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

## Usage

The `autovac_driver.py` script is used to run the AutoVacuum reinforcement learning process. It supports various command-line arguments to control its behavior:

```bash
python autovac_driver.py  - `--cmd [command] \
                         --max-episodes [max_episodes] \
                         --resume-id [resume_id] \
                         --experiment-duration [duration] \
                         --model-type [type] \
                         --model1-filename [filename1] \
                         --model2-filename [filename2] \
                         --instance-url [url] \
                         --instance-user [user] \
                         --instance-password [password] \
                         --instance-dbname [dbname]
```

Where:

 - `--cmd`: The command to execute (benchmark or learn).
 - `--max-episodes`: Maximum number of episodes for the experiment.
 - `--resume-id`: Identifier to resume from a previous state.
 - `--experiment-duration`: Duration of the experiment in seconds.
 - `--model-type`: Type of the model (simulated or real).
 - `--model1-filename`: Filename for the first model.
 - `--model2-filename`: Filename for the second model.
 - `--instance-url`: URL of the database instance.
 - `--instance-user`: Database user.
 - `--instance-password`: Database password.
 - `--instance-dbname`: Database name.

Replace the bracketed terms with your actual values. For example, to start a learning session, you might use:

To run the `autovac_driver.py` script, you need to provide command line arguments for the mode and parameters. Here are the command structures for each mode:

### Learn Mode
```bash
python autovac_driver.py --cmd learn --max-episodes 100 --resume-id 0 --experiment-duration 120 --model-type simulated --model1-filename model1.pt --model2-filename model2.pt --instance-url localhost --instance-user user --instance-password pass --instance-dbname mydb
```

### Benchmark Mode
```bash
python autovac_driver.py --cmd benchmark --max-episodes 100 --resume-id 0 --experiment-duration 120 --model-type simulated --model1-filename model1.pt --model2-filename model2.pt --instance-url localhost --instance-user user --instance-password pass --instance-dbname mydb
```

Replace the bracketed terms with your actual values.

## Configuration
TODO

## License

This project is licensed under the MIT License.
