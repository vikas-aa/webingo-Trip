import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/flight_model.dart';


class FlightDetailsScreen extends StatelessWidget {
  final FlightModel flight;

  const FlightDetailsScreen({
    super.key,
    required this.flight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Background gradient (same as screenshot)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE9EFFA),
                    Color(0xFFF4F6FA),
                    Color(0xFFF4F6FA),
                  ],
                  stops: [0.0, 0.35, 1.0],
                ),
              ),
            ),

            // Main content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
                child: Column(
                  children: [
                    _TopBar(onBack: () => Navigator.pop(context)),
                    const SizedBox(height: 14),

                    _FlightDetailsCard(flight: flight),
                    const SizedBox(height: 14),

                    const _PassengersCard(),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Positioned(
              left: 18,
              right: 18,
              bottom: 22,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(999),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF101114),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 26,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Download & Save pass",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
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
// TOP BAR (pixel perfect)
// ============================================================================
class _TopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _TopBar({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Title centered perfectly
          const Text(
            "Your flight details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0E0F12),
              letterSpacing: -0.2,
            ),
          ),

          // Back button left
          Align(
            alignment: Alignment.centerLeft,
            child: _CircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: onBack,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: Colors.black.withOpacity(0.75),
        ),
      ),
    );
  }
}

// ============================================================================
// FLIGHT DETAILS CARD
// ============================================================================
class _FlightDetailsCard extends StatelessWidget {
  final FlightModel flight;

  const _FlightDetailsCard({
    required this.flight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
          // Header row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: flight.logoBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  flight.logoText,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    color: flight.logoTextColor,
                    fontStyle: FontStyle.italic,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  flight.airlineName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0E0F12),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Text(
                flight.flightId,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.45),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Route row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AirportSide(
                time: flight.departTime,
                code: flight.departCode,
                city: flight.departCity,
                alignEnd: false,
              ),
              const Spacer(),

              // Center plane circle
              Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF101114).withOpacity(0.06),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.flight_takeoff_rounded,
                      size: 20,
                      color: const Color(0xFF2B67FF).withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    flight.duration,
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
                time: flight.arriveTime,
                code: flight.arriveCode,
                city: flight.arriveCity,
                alignEnd: true,
              ),
            ],
          ),

          const SizedBox(height: 12),

          _DottedDivider(color: Colors.black.withOpacity(0.10)),

          const SizedBox(height: 12),

          // Terminal / Gate / Class row
          Row(
            children: [
              _MiniInfo(title: "TERMINAL", value: flight.terminal),
              const Spacer(),
              _MiniInfo(title: "GATE", value: flight.gate),
              const Spacer(),
              _MiniInfo(title: "Class", value: flight.flightClass),
            ],
          ),
        ],
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
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2B67FF),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          code,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF101114),
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

class _MiniInfo extends StatelessWidget {
  final String title;
  final String value;

  const _MiniInfo({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.black.withOpacity(0.35),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: Color(0xFF101114),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// PASSENGERS CARD
// ============================================================================
class _PassengersCard extends StatelessWidget {
  const _PassengersCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Passengers Info",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0E0F12),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),

          const _PassengerRow(
            avatarUrl:
                "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300",
            passengerLabel: "PASSENGER 1",
            passengerName: "Mr. Budiarti Rohman",
            seat: "3A",
          ),

          const SizedBox(height: 12),
          _DottedDivider(color: Colors.black.withOpacity(0.10)),
          const SizedBox(height: 12),

          const _PassengerRow(
            avatarUrl:
                "https://images.unsplash.com/photo-1524503033411-f8b80c7f2f7b?w=300",
            passengerLabel: "PASSENGER 2",
            passengerName: "Mrs. Samantha William",
            seat: "3B",
          ),

          const SizedBox(height: 16),

          // Barcode
          const _Barcode(),
        ],
      ),
    );
  }
}

class _PassengerRow extends StatelessWidget {
  final String avatarUrl;
  final String passengerLabel;
  final String passengerName;
  final String seat;

  const _PassengerRow({
    required this.avatarUrl,
    required this.passengerLabel,
    required this.passengerName,
    required this.seat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(avatarUrl),
            ),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                passengerLabel,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withOpacity(0.35),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                passengerName,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF101114),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "SEAT",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.black.withOpacity(0.35),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              seat,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF101114),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// BARCODE (looks like screenshot)
// ============================================================================
class _Barcode extends StatelessWidget {
  const _Barcode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CustomPaint(
        painter: _BarcodePainter(),
      ),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF101114)
      ..style = PaintingStyle.fill;

    double x = 0;
    final h = size.height;

    // Better barcode pattern
    final bars = <double>[
      2, 1, 3, 1, 1, 4, 2, 1, 5, 1, 2, 1, 3, 1, 1, 6, 2, 1, 3, 1, 1,
      4, 2, 1, 5, 1, 2, 1, 3, 1, 1, 6, 2, 1, 3, 1, 1, 4, 2, 1, 5, 1,
      2, 1, 3, 1, 1, 6, 2, 1, 3, 1, 1, 4, 2, 1, 5, 1, 2, 1, 3, 1, 1,
      6, 2, 1, 3, 1, 1, 4, 2, 1, 5, 1,
    ];

    for (int i = 0; i < bars.length; i++) {
      final barW = bars[i];
      final isGap = i % 2 == 1;

      if (!isGap) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, 0, barW, h),
            const Radius.circular(1),
          ),
          paint,
        );
      }

      x += barW;

      if (x > size.width) break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// DOTTED DIVIDER
// ============================================================================
class _DottedDivider extends StatelessWidget {
  final Color color;
  const _DottedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        const dashW = 6.0;
        const dashSpace = 5.0;
        final count = (w / (dashW + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: dashW,
              height: 1.1,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      },
    );
  }
}
