# Base image for Python and Jupyter Notebook
FROM python:3.11-slim

# Install Rust (needed for Rust dependencies)
RUN apt-get update && apt-get install -y \
    curl \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && . $HOME/.cargo/env \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Rust to the PATH environment
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Jupyter Notebook
RUN pip install --no-cache-dir notebook

# Copy Jupyter Notebook and Python dependencies to the container
WORKDIR /app
COPY requirements.txt requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy Jupyter notebooks and code
COPY . .

# Expose the default Jupyter Notebook port
EXPOSE 8888

# Run Jupyter Notebook when the container starts
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
