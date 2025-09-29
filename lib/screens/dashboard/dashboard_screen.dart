
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedFilter = "Hoy";

  String _greetingByHour() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Buenos días';
    if (h < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = GoogleFonts.interTextTheme(theme.textTheme);

    final greeting = _greetingByHour();
    final progress = 0.72;
    final productivity = <double>[0.35, 0.62, 0.55, 0.78, 0.70, 0.92, 0.80];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: _HeroHeader(
                  title: '$greeting, Sophia 👋',
                  subtitle:
                      'Sigue así — ya completaste 5 de 7 tareas esta semana.',
                  progress: progress,
                ),
              ),
            ),

            // PROGRESO
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: _ProStatsCard(
                  title: 'Progreso (30 días)',
                  series: productivity,
                  formatter: (v) => '${(v * 100).toStringAsFixed(0)}%',
                ),
              ),
            ),

            // CHIPS DE FILTRO
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(
                        label: 'Hoy',
                        selected: _selectedFilter == 'Hoy',
                        icon: Icons.today_outlined,
                        onTap: () => setState(() => _selectedFilter = 'Hoy')),
                    _FilterChip(
                        label: 'Semana',
                        selected: _selectedFilter == 'Semana',
                        icon: Icons.calendar_view_week,
                        onTap: () =>
                            setState(() => _selectedFilter = 'Semana')),
                    _FilterChip(
                        label: 'Exámenes',
                        selected: _selectedFilter == 'Exámenes',
                        icon: Icons.school_outlined,
                        onTap: () =>
                            setState(() => _selectedFilter = 'Exámenes')),
                    _FilterChip(
                        label: 'Tareas',
                        selected: _selectedFilter == 'Tareas',
                        icon: Icons.checklist_outlined,
                        onTap: () =>
                            setState(() => _selectedFilter = 'Tareas')),
                    _FilterChip(
                        label: 'Tutorías',
                        selected: _selectedFilter == 'Tutorías',
                        icon: Icons.groups_2_outlined,
                        onTap: () =>
                            setState(() => _selectedFilter = 'Tutorías')),
                  ],
                ),
              ),
            ),

            // CONTENIDO FILTRADO
            SliverToBoxAdapter(
              child: _buildFilteredContent(),
            ),

            // ACCIONES RÁPIDAS
            SliverToBoxAdapter(
              child: _Section(
                title: 'Acciones rápidas',
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _QuickAction(
                        icon: Icons.add_task,
                        label: 'Nueva tarea',
                        onTap: () => context.go('/tasks')),
                    _QuickAction(
                        icon: Icons.event_available,
                        label: 'Agendar',
                        onTap: () => context.go('/calendar')),
                    _QuickAction(
                        icon: Icons.group_add_outlined,
                        label: 'Tutoría',
                        onTap: () => context.go('/tutoring')),
                  ],
                ),
              ),
            ),

            // BANNER TUTORING
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _TutoringBanner(onTap: () => context.go('/tutoring')),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        backgroundColor: cs.surface,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
        onTap: (i) {
          if (i == 0) return;
          if (i == 1) context.go('/tasks');
          if (i == 2) context.go('/tutoring');
          if (i == 3) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              activeIcon: Icon(Icons.people_alt),
              label: 'Tutoring'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildFilteredContent() {
    switch (_selectedFilter) {
      case "Hoy":
        return _Section(
          title: 'Agenda de hoy',
          child: Column(
            children: const [
              _TimelineItem(
                  time: '09:00',
                  title: 'Clase: Cálculo I',
                  subtitle: 'Edificio A - Aula 203',
                  colorIndex: 0),
              _TaskCard(
                  title: 'Ensayo: Historia 303',
                  subject: 'Historia',
                  due: 'Hoy • 23:59',
                  priority: Priority.high),
            ],
          ),
        );
      case "Semana":
        return _Section(
          title: 'Agenda de la semana',
          child: Column(
            children: const [
              _TimelineItem(
                  time: 'Martes',
                  title: 'Laboratorio Física',
                  subtitle: 'Bloque B - Lab 2',
                  colorIndex: 1),
              _TimelineItem(
                  time: 'Viernes',
                  title: 'Reunión de equipo',
                  subtitle: 'Proyecto Marketplace',
                  colorIndex: 2),
            ],
          ),
        );
      case "Exámenes":
        return _Section(
          title: 'Exámenes próximos',
          child: Column(
            children: const [
              _TaskCard(
                  title: 'Quiz Cap. 6',
                  subject: 'Biología',
                  due: 'Vie 11',
                  priority: Priority.low),
              _TaskCard(
                  title: 'Parcial Álgebra',
                  subject: 'Matemática',
                  due: 'Lun 14',
                  priority: Priority.high),
            ],
          ),
        );
      case "Tareas":
        return _Section(
          title: 'Pendientes',
          child: Column(
            children: const [
              _TaskCard(
                  title: 'Homework 4: Álgebra',
                  subject: 'Matemática',
                  due: 'Mañana',
                  priority: Priority.medium),
              _TaskCard(
                  title: 'Proyecto de Historia',
                  subject: 'Historia',
                  due: 'Próxima semana',
                  priority: Priority.low),
            ],
          ),
        );
      case "Tutorías":
        return _Section(
          title: 'Tutorías disponibles',
          child: Column(
            children: const [
              _TimelineItem(
                  time: '15:00',
                  title: 'Tutoría Matemática',
                  subtitle: 'Con David L.',
                  colorIndex: 0),
              _TimelineItem(
                  time: '17:00',
                  title: 'Tutoría Física',
                  subtitle: 'Con Sarah M.',
                  colorIndex: 1),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

/* ============================
 * Widgets internos
 * ============================ */

class _HeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  const _HeroHeader({
    required this.title,
    required this.subtitle,
    required this.progress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = GoogleFonts.interTextTheme(Theme.of(context).textTheme);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary.withOpacity(0.12),
            cs.secondaryContainer.withOpacity(0.24)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 76,
            width: 76,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress.clamp(0, 1),
                  strokeWidth: 8,
                  backgroundColor: cs.surfaceVariant,
                ),
                Text('${(progress * 100).toStringAsFixed(0)}%',
                    style: text.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: text.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: text.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        onSelected: (_) => onTap(),
        avatar: Icon(icon, size: 18),
        label: Text(label),
        showCheckmark: false,
        selectedColor: cs.secondaryContainer,
        side: BorderSide(color: cs.outlineVariant),
      ),
    );
  }
}
class _ProStatsCard extends StatelessWidget {
  final String title;
  final List<double> series;
  final String Function(double v) formatter;
  const _ProStatsCard({
    required this.title,
    required this.series,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = GoogleFonts.interTextTheme(Theme.of(context).textTheme);

    final last = series.isNotEmpty ? series.last : 0.0;
    final avg = series.isNotEmpty
        ? series.reduce((a, b) => a + b) / series.length
        : 0.0;
    final minV =
        series.isNotEmpty ? series.reduce((a, b) => a < b ? a : b) : 0.0;
    final maxV =
        series.isNotEmpty ? series.reduce((a, b) => a > b ? a : b) : 0.0;

    final delta = (last - avg);
    final deltaPct = (delta.abs() * 100).toStringAsFixed(0);
    final deltaIcon = delta >= 0 ? Icons.trending_up : Icons.trending_down;
    final deltaColor = delta >= 0 ? Colors.green : cs.error;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          children: [
            Row(
              children: [
                Text(title,
                    style: text.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: deltaColor.withOpacity(.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Icon(deltaIcon, size: 16, color: deltaColor),
                      const SizedBox(width: 6),
                      Text('${delta >= 0 ? '+' : '-'}$deltaPct%',
                          style: text.labelLarge?.copyWith(
                              color: deltaColor,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: CustomPaint(
                painter: _SparklinePainter(
                  series: series,
                  lineColor: cs.primary,
                  fillColor: cs.primary.withOpacity(.18),
                  gridColor: cs.outlineVariant,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LegendItem(label: 'Actual', value: formatter(last)),
                _LegendItem(label: 'Promedio', value: formatter(avg)),
                _LegendItem(label: 'Máx', value: formatter(maxV)),
                _LegendItem(label: 'Mín', value: formatter(minV)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> series;
  final Color lineColor;
  final Color fillColor;
  final Color gridColor;

  _SparklinePainter({
    required this.series,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;

    final grid = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final path = Path();
    final fillPath = Path();
    final dx = size.width / (series.length - 1).clamp(1, double.infinity);
    final points = <Offset>[];
    for (var i = 0; i < series.length; i++) {
      final x = i * dx;
      final y = size.height * (1 - series[i].clamp(0, 1));
      points.add(Offset(x, y));
    }

    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);

    fillPath.addPath(path, Offset.zero);
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.lineTo(points.first.dx, size.height);
    fillPath.close();

    final fillPaint = Paint()..color = fillColor;
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.series != series ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final String value;
  const _LegendItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    final text = GoogleFonts.interTextTheme(Theme.of(context).textTheme);
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label,
            style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value,
            style:
                text.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

// 🔹 AQUÍ YA NO VA OTRA CLASE _FilterChip. (Solo existe la de arriba con onTap)

class _TimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final int colorIndex;
  const _TimelineItem({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.colorIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final palette = [cs.primary, cs.secondary, cs.tertiary, cs.error];
    final color = palette[colorIndex % palette.length];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 64,
            child: Text(time,
                style: GoogleFonts.inter(fontWeight: FontWeight.w700))),
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Container(
                  width: 12,
                  height: 12,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle)),
              Container(
                  width: 2,
                  height: 44,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: cs.outlineVariant),
            ],
          ),
        ),
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(subtitle),
              trailing:
                  Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
              onTap: () => context.go('/calendar'),
            ),
          ),
        ),
      ],
    );
  }
}

enum Priority { low, medium, high }

class _TaskCard extends StatelessWidget {
  final String title;
  final String subject;
  final String due;
  final Priority priority;

  const _TaskCard(
      {required this.title,
      required this.subject,
      required this.due,
      required this.priority,
      super.key});

  Color _priorityColor(ColorScheme cs) {
    switch (priority) {
      case Priority.low:
        return cs.tertiary;
      case Priority.medium:
        return cs.primary;
      case Priority.high:
        return cs.error;
    }
  }

  String _priorityText() {
    switch (priority) {
      case Priority.low:
        return 'Baja';
      case Priority.medium:
        return 'Media';
      case Priority.high:
        return 'Alta';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      child: ListTile(
        onTap: () => context.go('/tasks'),
        title: Text(title,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              _Pill(
                  label: subject,
                  color: cs.secondaryContainer,
                  textColor: cs.onSecondaryContainer),
              const SizedBox(width: 6),
              Icon(Icons.schedule, size: 16, color: cs.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(due,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
        ),
        trailing: _Pill(
          label: _priorityText(),
          color: _priorityColor(cs).withOpacity(.12),
          textColor: _priorityColor(cs),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _Pill(
      {required this.label,
      required this.color,
      required this.textColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: textColor)),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 160,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: cs.outlineVariant),
        ),
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class _TutoringBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _TutoringBanner({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = GoogleFonts.interTextTheme(Theme.of(context).textTheme);

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: cs.secondaryContainer,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(Icons.support_agent,
              size: 40, color: cs.onSecondaryContainer),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '¿Necesitas refuerzo para el examen?\nEncuentra tu tutor ideal.',
              style: text.bodyLarge
                  ?.copyWith(color: cs.onSecondaryContainer, height: 1.25),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
              onPressed: onTap, child: const Text('Buscar tutor')),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  const _Section(
      {required this.title, required this.child, this.trailing, super.key});

  @override
  Widget build(BuildContext context) {
    final text = GoogleFonts.interTextTheme(Theme.of(context).textTheme);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              Text(title,
                  style: text.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
