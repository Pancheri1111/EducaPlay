import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeColorProvider = StateNotifierProvider<ThemeColorNotifier, Color>((ref) => ThemeColorNotifier());

class ThemeColorNotifier extends StateNotifier<Color> {
  ThemeColorNotifier() : super(Colors.orange) { _loadTheme(); }
  void _loadTheme() {
    final box = Hive.box('settings');
    state = Color(box.get('theme_color', defaultValue: Colors.orange.value));
  }
  void changeColor(Color color) {
    state = color;
    Hive.box('settings').put('theme_color', color.value);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) => LanguageNotifier());

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('Português') { _loadLanguage(); }
  void _loadLanguage() { 
    final saved = Hive.box('settings').get('language', defaultValue: 'Português');
    state = saved.toString().trim();
  }
  void changeLanguage(String lang) {
    state = lang;
    Hive.box('settings').put('language', lang);
  }

  String translate(String key) {
    final Map<String, Map<String, String>> d = {
      'Português': {
        'login': 'Entrar', 'register': 'Cadastrar', 'email': 'E-mail', 'password': 'Senha',
        'reg_btn': 'CADASTRAR E ENTRAR', 'has_acc': 'Já tenho conta? Conectar', 'no_acc': 'Não tem conta? Cadastre-se aqui',
        'welcome': 'Bem-vindo!', 'choose': 'O que vamos fazer hoje?', 'music': 'Músicas', 'reading': 'Leitura', 'games': 'Jogos', 'settings': 'Ajustes', 'logout': 'Sair',
        'math': 'Matemática', 'math_sub': 'Soma, Subtração, Mult e Divisão', 'ttt': 'Jogo da Velha', 'ttt_sub': 'Desafie o Robô!', 
        'mem': 'Memória', 'mem_sub': 'Encontre os pares de animais!', 'wm': 'Palavra e Imagem', 'wm_sub': 'Qual o nome do desenho?', 
        'tetris': 'Tetris', 'tetris_sub': 'Encaixe as peças coloridas!',
        'math_setup': 'Configurar Matemática', 'math_op': 'O que vamos praticar?', 'math_diff': 'Dificuldade:', 'math_check': 'CONFERIR',
        'ttt_cpu': 'Nível do Robô:', 'ttt_turn': 'Sua vez! (O)', 'ttt_win': 'Você venceu! 🎉', 'ttt_lose': 'O Robô venceu! 🤖', 'ttt_draw': 'Empatou! 🤝', 'reset': 'Reiniciar',
        'mem_setup': 'Configurar Memória', 'mem_pairs': 'Quantos pares?', 'mem_win': 'Parabéns! Você encontrou tudo!', 'progress': 'Progresso',
        'wm_q': 'Qual imagem combina com a palavra?', 'try_again': 'Ops! Tente de novo! ✍️', 'score': 'Pontos', 'best': 'Recorde', 'level': 'Nível',
        'easy': 'Fácil', 'medium': 'Médio', 'hard': 'Difícil', 'play': 'JOGAR', 'color': 'Cor', 'lang': 'Idioma', 'back': 'Voltar', 'guest': 'Entrar como Convidado',
        // --- LISTA DE 150 ITENS TRADUZIDOS (Para o Jogo de Palavras) ---
        'apple': 'Maçã', 'banana': 'Banana', 'orange': 'Laranja', 'strawberry': 'Morango', 'grape': 'Uva', 'pineapple': 'Abacaxi', 'watermelon': 'Melancia', 'cherry': 'Cereja', 'mango': 'Manga', 'pear': 'Pera', 'lemon': 'Limão', 'broccoli': 'Brócolis', 'carrot': 'Cenoura', 'corn': 'Milho', 'tomato': 'Tomate', 'potato': 'Batata', 'eggplant': 'Berinjela', 'cucumber': 'Pepino', 'mushroom': 'Cogumelo', 'bread': 'Pão', 'pizza': 'Pizza', 'burger': 'Hambúrguer', 'hot-dog': 'Cachorro-quente', 'cake': 'Bolo', 'cookie': 'Biscoito', 'ice-cream': 'Sorvete', 'donut': 'Rosquinha', 'chocolate': 'Chocolate', 'egg': 'Ovo', 'milk': 'Leite', 'cheese': 'Queijo', 'chicken': 'Frango', 'fish': 'Peixe', 'meat': 'Carne', 'crab': 'Caranguejo', 'shrimp': 'Camarão', 'octopus': 'Polvo', 'whale': 'Baleia', 'dolphin': 'Golfinho', 'shark': 'Tubarão', 'penguin': 'Pinguim', 'owl': 'Coruja', 'eagle': 'Águia', 'parrot': 'Papagaio', 'bee': 'Abelha', 'butterfly': 'Borboleta', 'ant': 'Formiga', 'spider': 'Aranha', 'scorpion': 'Escorpião', 'snake': 'Cobra', 'turtle': 'Tartaruga', 'frog': 'Sapo', 'lion': 'Leão', 'tiger': 'Tigre', 'bear': 'Urso', 'panda': 'Panda', 'koala': 'Koala', 'kangaroo': 'Canguru', 'elephant': 'Elefante', 'giraffe': 'Girafa', 'zebra': 'Zebra', 'monkey': 'Macaco', 'horse': 'Cavalo', 'cow': 'Vaca', 'pig': 'Porco', 'sheep': 'Ovelha', 'rabbit': 'Coelho', 'cat': 'Gato', 'dog': 'Cachorro', 'mouse': 'Rato', 'sun': 'Sol', 'moon': 'Lua', 'star': 'Estrela', 'cloud': 'Nuvem', 'rainbow': 'Arco-íris', 'rain': 'Chuva', 'snow': 'Neve', 'fire': 'Fogo', 'water': 'Água', 'tree': 'Árvore', 'flower': 'Flor', 'leaf': 'Folha', 'house': 'Casa', 'car': 'Carro', 'bicycle': 'Bicicleta', 'train': 'Trem', 'airplane': 'Avião', 'boat': 'Barco', 'rocket': 'Foguete', 'bus': 'Ônibus', 'truck': 'Caminhão', 'motorcycle': 'Moto', 'ambulance': 'Ambulância', 'fire-truck': 'Bombeiro', 'police-car': 'Polícia', 'taxi': 'Táxi', 'tractor': 'Trator', 'key': 'Chave', 'lock': 'Cadeado', 'clock': 'Relógio', 'watch': 'Relógio de Pulso', 'phone': 'Telefone', 'computer': 'Computador', 'laptop': 'Notebook', 'camera': 'Câmera', 'tv': 'Televisão', 'radio': 'Rádio', 'book': 'Livro', 'pencil': 'Lápis', 'pen': 'Caneta', 'scissors': 'Tesoura', 'hammer': 'Martelo', 'wrench': 'Chave de Boca', 'screwdriver': 'Chave de Fenda', 'ball': 'Bola', 'soccer-ball': 'Bola de Futebol', 'basketball': 'Bola de Basquete', 'guitar': 'Violão', 'piano': 'Piano', 'violin': 'Violino', 'drum': 'Tambor', 'trumpet': 'Trompete', 'bell': 'Sino', 'whistle': 'Apito', 'gift': 'Presente', 'balloon': 'Balão', 'hat': 'Chapéu', 'shirt': 'Camisa', 'pants': 'Calça', 'shoes': 'Sapato', 'socks': 'Meia', 'dress': 'Vestido', 'skirt': 'Saia', 'coat': 'Casaco', 'umbrella': 'Guarda-chuva', 'glasses': 'Óculos', 'ring': 'Anel', 'crown': 'Coroa', 'diamond': 'Diamante', 'sword': 'Espada', 'shield': 'Escudo', 'axe': 'Machado', 'bomb': 'Bomba', 'magnet': 'Ímã', 'battery': 'Bateria', 'light-bulb': 'Lâmpada', 'candle': 'Vela', 'compass': 'Bússola', 'telescope': 'Telescópio', 'microscope': 'Microscópio', 'ruler': 'Régua', 'calculator': 'Calculadora'
      },
      'English': {
        'login': 'Login', 'register': 'Sign Up', 'email': 'Email', 'password': 'Password',
        'reg_btn': 'REGISTER AND ENTER', 'has_acc': 'Already have account? Login', 'no_acc': 'Don\'t have account? Sign up',
        'welcome': 'Welcome!', 'choose': 'What shall we do today?', 'music': 'Music', 'reading': 'Reading', 'games': 'Games', 'settings': 'Settings', 'logout': 'Sign Out',
        'math': 'Math', 'math_sub': 'Have fun with numbers!', 'ttt': 'Tic Tac Toe', 'ttt_sub': 'Beat the Robot!', 
        'mem': 'Memory', 'mem_sub': 'Find matching animals!', 'wm': 'Word & Image', 'wm_sub': 'Match names to pictures', 
        'tetris': 'Tetris', 'tetris_sub': 'Fit everything perfectly!',
        'setup': 'Setup', 'difficulty': 'Difficulty', 'level': 'Level', 'score': 'Score', 'best': 'Best', 'check': 'CHECK', 'play': 'PLAY',
        'math_setup': 'Math Setup', 'math_op': 'Practice:', 'math_diff': 'Difficulty:', 'math_check': 'CHECK',
        'ttt_cpu': 'Robot Level:', 'ttt_turn': 'Your turn! (O)', 'ttt_win': 'You won! 🎉', 'ttt_lose': 'Robot won! 🤖', 'ttt_draw': 'It\'s a tie! 🤝', 'reset': 'Play Again',
        'mem_setup': 'Memory Setup', 'mem_pairs': 'How many pairs to find?', 'mem_win': 'Great! You found them all!', 'progress': 'Progress',
        'wm_q': 'Which image matches the word?', 'try_again': 'Oops! Try again! ✍️',
        'color': 'App Color', 'lang': 'Language', 'back': 'Back', 'guest': 'Enter as Guest'
      }
    };
    // FALLBACK DE SEGURANÇA: Se não achar na língua atual, tenta no Português.
    final currentLang = d[state] ?? d['Português']!;
    return currentLang[key] ?? d['Português']![key] ?? key;
  }
}
