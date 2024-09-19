# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create and set the working directory
WORKDIR /app

# Create a non-root user
RUN adduser --disabled-password --gecos '' myuser

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends gcc

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . .

# Change ownership of the app directory to myuser
RUN chown -R myuser:myuser /app

# Switch to non-root user
USER myuser

# Run gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
