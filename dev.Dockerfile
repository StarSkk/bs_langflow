FROM python:3.10-slim

WORKDIR /app

# Install Poetry
RUN apt-get update && apt-get install gcc g++ curl build-essential postgresql-server-dev-all -y
# install distutils for poetry (try)
# RUN apt install --reinstall -y python3-distutils
RUN curl -sSL https://install.python-poetry.org | python3 -
# # Add Poetry to PATH
ENV PATH="${PATH}:/root/.local/bin"
# # Copy the pyproject.toml and poetry.lock files
COPY poetry.lock pyproject.toml ./
# Copy the rest of the application codes
COPY ./ ./

# change tsinghua source
RUN poetry source add --priority=default mirrors https://pypi.tuna.tsinghua.edu.cn/simple/
# RUN poetry lock --no-update
# Install dependencies
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

CMD ["uvicorn", "langflow.main:app", "--host", "0.0.0.0", "--port", "5003", "--reload", "log-level", "debug"]