# EducaPlay - App Educativo Infantil

O EducaPlay e um aplicativo desenvolvido em Flutter focado em alfabetizacao, raciocinio logico e diversao segura para criancas. O projeto utiliza uma arquitetura simples e eficiente, ideal para estudantes e desenvolvedores iniciantes.

---

## Como Rodar o Projeto

1. Pre-requisitos: Ter o Flutter SDK instalado em sua maquina.
2. Instalar Dependencias:
   ```bash
   flutter pub get
   ```
3. Executar o Aplicativo:
   - Para teste rapido de interface: `flutter run -d chrome` (Recomendado para quem vai mexer apenas no visual).
   - Para teste no celular: `flutter run -d android` (Pode demorar na primeira execucao para baixar o NDK).

---

## Guia para os Desenvolvedores (Equipe)

Cada integrante deve focar em sua area conforme combinado na estrutura de pastas em `lib/pages/`:

- **Login e Cadastro:** Focar no arquivo `login_page.dart`.
- **Modulo de Musica:** Implementar funcoes no arquivo `music_page.dart`.
- **Modulo de Leitura:** Refinar as historias no arquivo `reading_page.dart`.
- **Estrutura e Jogos:** (Area do Lider do Projeto) arquivos `games_page.dart` e `math_game_page.dart`.

**Dica importante:** Se for testar no Android pela primeira vez, o Flutter pode baixar pacotes pesados (NDK). Se estiver com pressa, use o Chrome (`-d chrome`), que e instantaneo e nao precisa desses pacotes.

---

## Funcionalidades Principais

### 1. Modulo de Leitura
Permite que a crianca leia historias magicas e que o usuario adicione novos livros. Usa flutter_tts para leitura em voz alta.

### 2. Modulo de Jogos (Matematica Infinita)
Desafio matematico com dificuldade progressiva. Recordes sao salvos localmente com Hive.

### 3. Modulo de Musica
Player de audio para musicas educativas.

---

## Estrutura Tecnica (Flutter + Java)

O projeto foi estruturado para ser simples e didatico:
- Linguagem Principal: Flutter (Dart).
- Linguagem Nativa (Android): Java.
- Gerenciamento de Estado: Riverpod.
- Banco de Dados Local: Hive.

---

## Organizacao de Arquivos
- `lib/main.dart`: Entrada e rotas.
- `lib/pages/`: Todas as telas do app.

-------------------

### COMANDOS DE MANUTENCAO

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

### Equipe de Desenvolvimento e Licenca:
Desenvolvido por:
- Equipe EducaPlay
- Giovanni Silveira

Licenca: MIT - Uso educacional livre.
