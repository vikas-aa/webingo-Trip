import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/bottom_nav.dart';
import 'package:flutter_application_1/Screens/flight_result.dart';


class TripHomeScreen extends StatefulWidget {
  const TripHomeScreen({super.key});

  @override
  State<TripHomeScreen> createState() => _TripHomeScreenState();
}

class _TripHomeScreenState extends State<TripHomeScreen> {
  String fromCity = "Jakarta (CGK)";
  String toCity = "Tokyo (NRT)";
  DateTime selectedDate = DateTime(2025, 4, 2);
  int people = 3;

  int bottomIndex = 0;

  String _formatDate(DateTime d) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    final day = days[d.weekday - 1];
    final month = months[d.month - 1];
    return "$day, ${d.day} $month";
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _C.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _C.text,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) setState(() => selectedDate = picked);
  }

  void _swapFromTo() {
    setState(() {
      final t = fromCity;
      fromCity = toCity;
      toCity = t;
    });
  }

  void _searchFlights() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FlightResultScreen(
        fromCity: fromCity,
        toCity: toCity,
        date: selectedDate,
        people: people,
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ Bottom Nav (ALAG FILE)
      bottomNavigationBar: TripBottomNav(
        currentIndex: bottomIndex,
        onTap: (i) => setState(() => bottomIndex = i),
      ),

      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const _TripBackground(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),

                    // Title + Avatar
                    Row(
                      children: const [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 22),
                            child: Text(
                              "Plan your trip",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.05,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                        _Avatar(),
                      ],
                    ),

                    const SizedBox(height: 22),

                    _SearchCard(
                      fromCity: fromCity,
                      toCity: toCity,
                      dateText: _formatDate(selectedDate),
                      people: people,
                      onSwap: _swapFromTo,
                      onPickDate: _pickDate,
                      onPeopleChanged: (v) => setState(() => people = v),
                      onSearch: _searchFlights,
                    ),

                    const SizedBox(height: 26),

                    Row(
                      children: [
                        const Text(
                          "Saved trips",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _C.text,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "See more",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.45),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (_, __) => const _TicketSavedTrip(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// COLORS
// ============================================================================
class _C {
  static const blue = Color(0xFF2B67FF);
  static const text = Color(0xFF101114);
  static const muted = Color(0xFF97A0B0);
}

// ============================================================================
// BACKGROUND
// ============================================================================
class _TripBackground extends StatelessWidget {
  const _TripBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2B67FF),
            Color(0xFF76A7F6),
            Color(0xFFEFF4FB),
            Color(0xFFFFFFFF),
          ],
          stops: [0.0, 0.33, 0.70, 1.0],
        ),
      ),
    );
  }
}

// ============================================================================
// AVATAR
// ============================================================================
class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.92), width: 2.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400",
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SEARCH CARD
// ============================================================================
class _SearchCard extends StatelessWidget {
  final String fromCity;
  final String toCity;
  final String dateText;
  final int people;

  final VoidCallback onSwap;
  final VoidCallback onPickDate;
  final ValueChanged<int> onPeopleChanged;
  final VoidCallback onSearch;

  const _SearchCard({
    required this.fromCity,
    required this.toCity,
    required this.dateText,
    required this.people,
    required this.onSwap,
    required this.onPickDate,
    required this.onPeopleChanged,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.52),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.70), width: 1.2),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Label("From"),
                  const SizedBox(height: 4),
                  _Value(fromCity),

                  const SizedBox(height: 12),
                  Divider(height: 1, thickness: 1, color: Colors.black.withOpacity(0.06)),
                  const SizedBox(height: 12),

                  const _Label("To"),
                  const SizedBox(height: 4),
                  _Value(toCity),

                  const SizedBox(height: 14),
                  Divider(height: 1, thickness: 1, color: Colors.black.withOpacity(0.06)),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _DepartureField(
                          dateText: dateText,
                          onPickDate: onPickDate,
                        ),
                      ),
                      Expanded(
                        child: _PeopleDropdown(
                          value: people,
                          onChanged: onPeopleChanged,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Positioned(
                right: 0,
                top: 34,
                child: InkWell(
                  onTap: onSwap,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.52),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.swap_vert_rounded,
                      size: 22,
                      color: Colors.black.withOpacity(0.70),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          InkWell(
            onTap: onSearch,
            borderRadius: BorderRadius.circular(26),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: _C.text,
                borderRadius: BorderRadius.circular(26),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Search flights",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: _C.muted,
      ),
    );
  }
}

class _Value extends StatelessWidget {
  final String text;
  const _Value(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: _C.text,
        letterSpacing: -0.25,
      ),
    );
  }
}

class _DepartureField extends StatelessWidget {
  final String dateText;
  final VoidCallback onPickDate;

  const _DepartureField({
    required this.dateText,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label("Departure"),
        const SizedBox(height: 6),
        InkWell(
          onTap: onPickDate,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              Text(
                dateText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: _C.text,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 16,
                  color: Colors.black.withOpacity(0.65),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _PeopleDropdown extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _PeopleDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label("Amount"),
        const SizedBox(height: 6),
        SizedBox(
          height: 28,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: Colors.black.withOpacity(0.65),
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text("1 people")),
                DropdownMenuItem(value: 2, child: Text("2 people")),
                DropdownMenuItem(value: 3, child: Text("3 people")),
                DropdownMenuItem(value: 4, child: Text("4 people")),
                DropdownMenuItem(value: 5, child: Text("5 people")),
              ],
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: _C.text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// TICKET
// ============================================================================
class _TicketSavedTrip extends StatelessWidget {
  const _TicketSavedTrip();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TicketNotchClipper(),
      child: Container(
        width: 310,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 22,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              "Citilink",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0D8B57),
                fontStyle: FontStyle.italic,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AirportSide(
                  time: "07:47",
                  code: "CGK",
                  city: "(Jakarta)",
                  alignEnd: false,
                ),
                const Spacer(),
                Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.flight_takeoff_rounded,
                        size: 20,
                        color: _C.blue.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "7h 15m",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _AirportSide(
                  time: "14:30",
                  code: "NRT",
                  city: "(Tokyo)",
                  alignEnd: true,
                ),
              ],
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _DottedDivider(
                color: Colors.black.withOpacity(0.18),
                dashWidth: 5,
                dashSpace: 5,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                _DateBlock(alignEnd: false),
                Spacer(),
                _DateBlock(alignEnd: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AirportSide extends StatelessWidget {
  final String time;
  final String code;
  final String city;
  final bool alignEnd;

  const _AirportSide({
    required this.time,
    required this.code,
    required this.city,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: _C.blue,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          code,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: _C.text,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          city,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.45),
          ),
        ),
      ],
    );
  }
}

class _DateBlock extends StatelessWidget {
  final bool alignEnd;
  const _DateBlock({required this.alignEnd});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: const [
        Text(
          "DATE",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Color(0xFF9AA2B1),
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Jan 20, 2025",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: _C.text,
          ),
        ),
      ],
    );
  }
}

class _DottedDivider extends StatelessWidget {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const _DottedDivider({
    required this.color,
    this.dashWidth = 6,
    this.dashSpace = 6,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final count = (w / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1.2,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}

class _TicketNotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const r = 16.0;
    const notchRadius = 14.0;

    final p = Path();

    p.moveTo(r, 0);
    p.quadraticBezierTo(0, 0, 0, r);

    p.lineTo(0, size.height * 0.50 - notchRadius);
    p.arcToPoint(
      Offset(0, size.height * 0.50 + notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    p.lineTo(0, size.height - r);
    p.quadraticBezierTo(0, size.height, r, size.height);

    p.lineTo(size.width - r, size.height);
    p.quadraticBezierTo(size.width, size.height, size.width, size.height - r);

    p.lineTo(size.width, size.height * 0.50 + notchRadius);
    p.arcToPoint(
      Offset(size.width, size.height * 0.50 - notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    p.lineTo(size.width, r);
    p.quadraticBezierTo(size.width, 0, size.width - r, 0);

    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
