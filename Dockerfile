# Usar una imagen oficial de Python ligera
FROM python:3.9-slim

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app

# Copiar los archivos de requerimientos e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código (incluyendo vulnerable_app.py y create_db.py)
COPY . .

# Inicializar la base de datos de SQLite antes de arrancar
RUN python create_db.py

# Exponer el puerto donde corre Flask
EXPOSE 5000

# Comando para ejecutar la aplicación
CMD ["python", "vulnerable_app.py"]