# breath_bank

BreathBank app.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

En este apartado se van a definir los diferentes datos que se van a procesar al usar la aplicación.
Al utilizar Firebase, una base de datos no relacional, no se almacena en forma de tablas como estamos acostumbrados a trabajar en la carrera, si no que se almacena como si fuese un árbol con tipo de datos -JSON, que son archivos de textos bastante accesible para las aplicaciones. La estructura funciona de la siguiente manera, como raíz está una colección principal, dentro de esa colección va un documento, y como hijo de este documento se pueden introducir campos o una subcolección que funcionaría de la misma forma que la colección de la raíz, por lo que el árbol se formaría con diversas ramas. 
Variables de sesión
Los datos de variables de sesión se guardan automáticamente mediante la función Authentication de Firebase, que se implementa en el código de manera sencilla y con pocas líneas de código. También genera un árbol en el que por cada usuario hay un límite de datos para poder guardar.
