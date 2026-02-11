import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créditos'),
        elevation: 0,
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              Colors.white.withOpacity(0.9),
              const Color(0xFFFEF2F2), // Rosa suave
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Ícone principal decorativo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),

              // Título principal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  'EducaPlay',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              // Subtítulo
              Text(
                'Aprendendo brincando',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),

              // Card principal - Desenvolvedores
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Desenvolvido com ❤️ por',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Desenvolvedor 1
                    _buildDeveloperCard(
                      name: 'Renan Pancheri',
                      role: 'Lead Developer',
                      icon: Icons.code,
                    ),
                    const SizedBox(height: 16),

                    // Desenvolvedor 2
                    _buildDeveloperCard(
                      name: 'Wagner Felipe',
                      role: 'Arquiteto de Software',
                      icon: Icons.architecture,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Seção de Colaboradores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Colaboradores do Projeto',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lista de colaboradores
                    _buildCollaboratorCard(
                      title: '🎨 Design & UI/UX',
                      collaborators: ['Equipe de Design EducaPlay'],
                    ),
                    const SizedBox(height: 12),

                    _buildCollaboratorCard(
                      title: '🧪 Testes & QA',
                      collaborators: ['Equipe de Qualidade'],
                    ),
                    const SizedBox(height: 12),

                    _buildCollaboratorCard(
                      title: '📚 Conteúdo Educativo',
                      collaborators: ['Especialistas em Educação Infantil'],
                    ),
                    const SizedBox(height: 12),

                    _buildCollaboratorCard(
                      title: '🎵 Trilha Sonora',
                      collaborators: ['Compositores Infantis'],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Versão do App
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  border: Border.all(
                    color: AppColors.tertiary.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Versão da Aplicação',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'v1.0.0 (Build 1)',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.tertiary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lançado em 11 de Fevereiro de 2026',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Seção de Agradecimentos
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withOpacity(0.1),
                      AppColors.tertiary.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppColors.secondary,
                      size: 28,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Obrigado por usar EducaPlay!',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estamos sempre prontos para ouvir suas sugestões e melhorias.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Links / Informações adicionais
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Made with 🎨 Flutter & ❤️ Love',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© 2026 EducaPlay. Todos os direitos reservados.',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Card para exibir informações do desenvolvedor
  Widget _buildDeveloperCard({
    required String name,
    required String role,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card para exibir informações de colaboradores
  Widget _buildCollaboratorCard({
    required String title,
    required List<String> collaborators,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...collaborators.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.tertiary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
