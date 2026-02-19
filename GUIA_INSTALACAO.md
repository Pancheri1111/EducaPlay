# ⚡ Guia de Instalação e Execução - EducaPlay

## 📋 Pré-requisitos

- **Flutter SDK** >= 3.0.0
- **Dart SDK** >= 3.0.0
- **Visual Studio Code** ou Android Studio
- **Android SDK** (minSdkVersion: 21)
- **Emulador ou Dispositivo** (Android/Windows)

---

## 🚀 Passo 1: Preparar o Ambiente

### 1.1 Abrir Terminal PowerShell
```powershell
# Navegar até o projeto
cd c:\Users\adrif\Documents\flutter_application_1
```

### 1.2 Limpar Cache (se necessário)
```bash
flutter clean
```

---

## 📦 Passo 2: Instalar Dependências

```bash
# Baixar todas as dependências do pubspec.yaml
flutter pub get

# Gerar código Hive (necessário para persistência)
flutter pub run build_runner build
```

**Espere até ver:**
```
✓ Built build/ios/...
✓ Built build/android/...
```

---

## 🎮 Passo 3: Executar a Aplicação

### Opção A: Android (Emulador ou Dispositivo)
```bash
# Listar dispositivos disponíveis
flutter devices

# Rodar no primeiro dispositivo
flutter run

# Ou especificar dispositivo
flutter run -d <device-id>
```

### Opção B: Windows (Desktop)
```bash
# Habilitar Windows como plataforma
flutter config --enable-windows-desktop

# Rodar
flutter run -d windows
```

### Opção C: Modo Hot Reload (Desenvolvimento)
```bash
flutter run
# Depois pressione 'r' para hot reload
# Pressione 'R' para hot restart
```

---

## 📱 Passo 4: Testar Funcionalidades

### Login Screen ✅
1. Abra o app
2. Digite seu nome
3. Escolha "Criança" ou "Educador"
4. Clique "Entrar"

### Módulo de Música 🎵
1. Abra a aba "Música"
2. Clique no botão [+] (Adicionar Música)
3. Selecione um arquivo `.mp3` do dispositivo
4. A música aparecerá na lista
5. Clique para tocar
6. Use os botões de controle (Play/Pause/Stop)

### Módulo de Leitura 📖
1. Abra a aba "Leitura"
2. Clique no botão [+] (Adicionar História)
3. Escolha:
   - **Manual:** Digite uma história
   - **Arquivo:** Selecione um `.txt`
4. A história aparecerá na lista
5. Clique para abrir a história
6. Clique em [Ouvir com IA] para ouvir narração

### Módulo de Jogos 🎮
1. Abra a aba "Jogos"
2. Clique em "Matemática Infinita"
3. Responda as contas clicando nos números
4. Cada acerto aumenta sua pontuação
5. A dificuldade aumenta gradualmente
6. Não há fim - continue jogando!

---

## 🐛 Troubleshooting

### Erro: "lib/main.dart not found"
```bash
# Certifique-se de que está no diretório correto
cd c:\Users\adrif\Documents\flutter_application_1
ls lib/main.dart  # Deve listar o arquivo
```

### Erro: "Dependências faltando"
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
```

### Erro: "Permissões de arquivo"
**Android:**
```bash
# Editar android/app/src/main/AndroidManifest.xml
# Adicionar:
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

**Windows:**  
Geralmente funciona nativo sem configuração

### Erro: "Audio não funciona"
```bash
# Certifique-se de que audioplayers está instalado
flutter pub get
```

### Erro: "TTS não fala"
```bash
# Verificar idioma português brasileiro
# Vá em Configurações > Idioma > Português (Brasil)
```

---

## 📊 Verificar a Instalação

```bash
# Verificar versão do Flutter
flutter --version

# Verificar integridade do projeto
flutter doctor

# Listar dependências instaladas
flutter pub deps
```

---

## 🎯 Checklist de Instalação

- [ ] Flutter SDK está instalado
- [ ] `flutter pub get` executado com sucesso
- [ ] `build_runner build` executado sem erros
- [ ] Dispositivo conectado ou emulador ativo
- [ ] Arquivos musicais existem para teste
- [ ] Arquivos .txt existem para teste
- [ ] App inicia sem erros
- [ ] Login funciona
- [ ] Música plays corretamente
- [ ] TTS fala em português
- [ ] Jogos funcionam infinitamente

---

## 🔧 Variáveis de Ambiente (Opcional)

```powershell
# Definir variáveis no PowerShell
$env:FLUTTER_ROOT = "C:\flutter"
$env:ANDROID_SDK_ROOT = "C:\Android\sdk"
```

---

## 📚 Recursos Úteis

- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Docs](https://riverpod.dev)
- [Hive Database](https://pub.dev/packages/hive)
- [Audioplayers](https://pub.dev/packages/audioplayers)
- [Flutter TTS](https://pub.dev/packages/flutter_tts)

---

## ✅ Conclusão

Se tudo correu bem, você verá:
1. Tela de login
2. Botão de entrada
3. 3 abas funcionando
4. Dados persistindo localmente
5. Tudo operando offline

**Parabéns! EducaPlay está pronto para usar! 🎉**
=
