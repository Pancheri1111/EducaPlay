# EducaPlay - App Educativo Infantil

O EducaPlay e um aplicativo desenvolvido em Flutter focado em alfabetizacao, raciocinio logico e diversao segura para criancas. O projeto utiliza uma arquitetura simples e eficiente, ideal para estudantes e desenvolvedores iniciantes.

---

## Como Rodar o Projeto

1. Pré-requisitos: Ter o Flutter instalado em sua máquina.
2. Instalar Dependencias:
   ```bash
   flutter pub get
   ```
3. Executar no Emulador/Celular:
   ```bash
   flutter run -d android
   ```
   *(Ou use o Chrome com `flutter run -d chrome`)*

---

## Funcionalidades Principais

### 1. Modulo de Leitura
Permite que a crianca leia historias magicas. 
- Diferencial: O usuario (ou professor) pode adicionar seus proprios livros em formato de texto.
- Tecnologia: Usa flutter_tts para que a Inteligencia Artificial leia a historia em voz alta para a crianca.

### 2. Modulo de Jogos (Matematica Infinita)
Um desafio matematico que nunca acaba!
- Dificuldade Progressiva: Quanto mais a crianca acerta, mais os numeros aumentam, estimulando o raciocinio.
- Persistencia: O recorde (High Score) fica salvo no dispositivo usando o banco de dados Hive.

### 3. Modulo de Musica
Player de audio simples para tocar musicas educativas salvos no dispositivo.

---

## Estrutura Tecnica (Flutter + Java)

O projeto foi estruturado para ser simples e didatico:
- Linguagem Principal: Flutter (Dart).
- Linguagem Nativa (Android): Java (configurado na pasta android/app/src/main/java).
- Gerenciamento de Estado: Riverpod (para manter o app leve).
- Banco de Dados Local: Hive (salvamento assincrono e rapido).

---

## Organizacao de Arquivos
- lib/main.dart: Ponto de entrada e rotas do app.
- lib/pages/: Contem todas as telas do aplicativo (Login, Menu, Jogos, Leitura, Música).

---

## Notas de Implementacao (Sprint 1)
- Estrutura simplificada para facil manutencao.
- Foco em performance e economia de bateria (uso de const e dispose).
- Suporte total a dispositivos Android e Windows.

-------------------

### COMANDOS DE MANUTENCAO (PARA DESENVOLVEDORES)

**Limpar o projeto:**
```bash
flutter clean
flutter pub get
```

**Gerar APK para teste:**
```bash
flutter build apk --release
```

-------------------

### Desenvolvido por:
Equipe EducaPlay - Focado em Educacao e Tecnologia.
