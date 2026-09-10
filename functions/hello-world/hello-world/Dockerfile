FROM python:3.11-slim AS build-stage
WORKDIR /function

# Install dependencies into an isolated prefix that matches the function runtime layout
COPY requirements.txt /function/requirements.txt
# Install into /python so we can copy the exact directory into the runtime image
RUN pip install --no-cache-dir --no-warn-script-location --target=/python -r /function/requirements.txt

# Copy function source
COPY . /function

FROM python:3.11-slim
WORKDIR /function

# Copy installed packages and function code from build stage
COPY --from=build-stage /python /python
COPY --from=build-stage /function /function

ENV PATH="/python/bin:${PATH}"
# Ensure Python looks for packages installed under /python (pip --target)
ENV PYTHONPATH="/python"

# Use the FDK entrypoint to run the function handler
CMD ["/python/bin/fdk", "/function/func.py", "handler"]
