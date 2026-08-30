
***

# PLE-Activity-P1


## Macro Estructura

```text
PLE-Activity-P1/
├── rascal-projects.code-workspace
└── <nombre-actividad>/
    ├── README.md              # Breve descripción sobre que trata el ejercicio
    ├── report/                # Explicación formal (LaTeX)
    ├── FOR_STUDENTS/          # Base de trabajo para los estudiantes
    │   └── <proyecto-base>/
    │       ├── pom.xml
    │       ├── META-INF/RASCAL.MF
    │       └── src/main/rascal/
    │           ├── Syntax.rsc     # Gramática a completar
    │           ├── Main.rsc       # Punto de entrada
    │           ├── Plugin.rsc     # Integración con el entorno
    │           └── instance/      # Ejemplos de entrada/salida
    └── FOR_TA/                # Material guia para los monitores
        ├── session_script.md  # Como se deberia de guiarse una tutoria con este ejercicio
        ├── ta_guide.md        # Que esperar del ejercicio 
        └── reference_solutions/
```

> **Nota:** El contenido de `FOR_STUDENTS` debe ser autosuficiente para realizar la práctica sin revelar la solución. Todo material de corrección, guías de sesión o respuestas deben estar estrictamente en `FOR_TA` y no ser compatido con los estudiantes.

## Flujo de Trabajo

Para crear o adaptar un ejercicio bajo este patrón:

1.  **Inicializar:** Copia la estructura base dentro de una nueva carpeta `<nombre-actividad>`.
2.  **Definir:** Implementa la gramática (`Syntax.rsc`) y la lógica principal en `FOR_STUDENTS`.
3.  **Validar:** Añade casos de prueba concretos en `instance/` para verificar comportamientos válidos e inválidos.
4.  **Documentar:** Describe el objetivo, instrucciones de ejecución y entregables en el `README.md` de la actividad.
5.  **Separar:** Mueve soluciones y notas de evaluación a `FOR_TA` antes de publicar el material a los estudiantes.