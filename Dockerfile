FROM python:3.10-slim

# Prevent Python from writing .pyc files & enable logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies (lightweight)
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (better cache)
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the backend (models INCLUDED)
COPY . .

# Hugging Face Spaces uses port 7860
EXPOSE 7860

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]
