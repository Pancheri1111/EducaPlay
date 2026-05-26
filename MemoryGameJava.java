import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

/**
 * Jogo da Memória Educativo em Java
 * Com dificuldades (8, 15, 30 pares) e seleção aleatória de imagens
 */
public class MemoryGameJava {
    private static final int TOTAL_IMAGES = 30;
    private int[][] board;
    private boolean[][] revealed;
    private boolean[][] matched;
    private int currentPairs;
    private int moves;
    private int matchedCount;
    private int bestScore;
    private Random random;
    private int firstSelectedIndex;
    private boolean waiting;

    public MemoryGameJava(int pairCount) {
        this.currentPairs = Math.min(pairCount, TOTAL_IMAGES);
        this.random = new Random();
        this.firstSelectedIndex = -1;
        this.waiting = false;
        this.moves = 0;
        this.matchedCount = 0;
        this.bestScore = Integer.MAX_VALUE;
        initializeGame();
    }

    /**
     * Inicializa o tabuleiro com pares aleatórios
     */
    private void initializeGame() {
        int totalCards = currentPairs * 2;
        board = new int[totalCards][1];
        revealed = new boolean[totalCards][1];
        matched = new boolean[totalCards][1];

        // Cria lista de imagens disponíveis
        List<Integer> imageIds = new ArrayList<>();
        for (int i = 1; i <= TOTAL_IMAGES; i++) {
            imageIds.add(i);
        }

        // Embaralha e seleciona pares aleatórios
        Collections.shuffle(imageIds, random);
        List<Integer> selectedPairs = imageIds.subList(0, currentPairs);

        // Cria pares e embaralha novamente
        List<Integer> cardList = new ArrayList<>();
        for (Integer imageId : selectedPairs) {
            cardList.add(imageId);
            cardList.add(imageId);
        }
        Collections.shuffle(cardList, random);

        // Preenche o tabuleiro
        for (int i = 0; i < totalCards; i++) {
            board[i][0] = cardList.get(i);
            revealed[i][0] = false;
            matched[i][0] = false;
        }

        moves = 0;
        matchedCount = 0;
    }

    /**
     * Seleciona uma carta
     */
    public boolean selectCard(int index) {
        if (waiting || matched[index][0] || revealed[index][0]) {
            return false;
        }

        revealed[index][0] = true;

        if (firstSelectedIndex == -1) {
            firstSelectedIndex = index;
            return true;
        }

        moves++;
        int firstImageId = board[firstSelectedIndex][0];
        int secondImageId = board[index][0];

        if (firstImageId == secondImageId) {
            matched[firstSelectedIndex][0] = true;
            matched[index][0] = true;
            matchedCount++;
            firstSelectedIndex = -1;
            return true;
        }

        waiting = true;
        firstSelectedIndex = -1;
        return false;
    }

    /**
     * Revela as cartas incorretas após tempo
     */
    public void revealIncorrectCards(int firstIndex, int secondIndex) {
        try {
            Thread.sleep(800);
            revealed[firstIndex][0] = false;
            revealed[secondIndex][0] = false;
            waiting = false;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    /**
     * Verifica se o jogo terminou
     */
    public boolean isGameOver() {
        return matchedCount == currentPairs;
    }

    /**
     * Finaliza o jogo e atualiza melhor pontuação
     */
    public void finishGame() {
        if (moves < bestScore) {
            bestScore = moves;
        }
    }

    /**
     * Reinicia o jogo
     */
    public void resetGame() {
        initializeGame();
    }

    /**
     * Getters
     */
    public int getMoves() {
        return moves;
    }

    public int getMatchedCount() {
        return matchedCount;
    }

    public int getCurrentPairs() {
        return currentPairs;
    }

    public int getBestScore() {
        return bestScore == Integer.MAX_VALUE ? 0 : bestScore;
    }

    public boolean isRevealed(int index) {
        return revealed[index][0];
    }

    public boolean isMatched(int index) {
        return matched[index][0];
    }

    public int getCardImageId(int index) {
        return board[index][0];
    }

    public int getTotalCards() {
        return currentPairs * 2;
    }

    public boolean isWaiting() {
        return waiting;
    }

    public static void main(String[] args) {
        MemoryGameJava game = new MemoryGameJava(8);

        System.out.println("=== Jogo da Memória em Java ===");
        System.out.println("Pares: " + game.getCurrentPairs());
        System.out.println("Total de cartas: " + game.getTotalCards());
        System.out.println("Modo educativo com embaralhamento aleatório\n");

        // Exemplo de uso
        System.out.println("Selecionando carta 0...");
        game.selectCard(0);
        System.out.println("Movimentos: " + game.getMoves());

        System.out.println("\nSelecionando carta 1...");
        game.selectCard(1);
        System.out.println("Movimentos: " + game.getMoves());

        System.out.println("\nMelhor pontuação: " + game.getBestScore());
    }
}
