import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/flight_model.dart';
import 'package:flutter_application_1/Screens/flight_details.dart';


class FlightResultScreen extends StatefulWidget {
  final String fromCity;
  final String toCity;
  final DateTime date;
  final int people;

  const FlightResultScreen({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.people,
  });

  @override
  State<FlightResultScreen> createState() => _FlightResultScreenState();
}

class _FlightResultScreenState extends State<FlightResultScreen> {
  int activeFilter = 0;
  int? selectedIndex;

  late final List<FlightModel> flights = const [
    FlightModel(
      airlineName: "Citilink Airline",
      flightId: "ID3242113",
      logoText: "Citilink",
      logoBg: Color(0xFFE7F7EE),
      logoTextColor: Color(0xFF0D8B57),
      departTime: "07:47",
      arriveTime: "14:30",
      departCode: "CGK",
      departCity: "(Jakarta)",
      arriveCode: "NRT",
      arriveCity: "(Tokyo)",
      duration: "7h 15m",
      price: 321,
      terminal: "2A",
      gate: "19",
      flightClass: "Economy",
    ),
    FlightModel(
      airlineName: "Catty Airline",
      flightId: "ID7845210",
      logoText: "CattyAir",
      logoBg: Color(0xFFFFE8E8),
      logoTextColor: Color(0xFFCC2E2E),
      departTime: "07:47",
      arriveTime: "14:30",
      departCode: "CGK",
      departCity: "(Jakarta)",
      arriveCode: "NRT",
      arriveCity: "(Tokyo)",
      duration: "7h 20m",
      price: 321,
      terminal: "1B",
      gate: "06",
      flightClass: "Economy",
    ),
    FlightModel(
      airlineName: "Bird Indonesia Airline",
      flightId: "ID1129008",
      logoText: "Bird",
      logoBg: Color(0xFFEAF1FF),
      logoTextColor: Color(0xFF2B67FF),
      departTime: "07:47",
      arriveTime: "14:30",
      departCode: "CGK",
      departCity: "(Jakarta)",
      arriveCode: "NRT",
      arriveCity: "(Tokyo)",
      duration: "7h 20m",
      price: 321,
      terminal: "3A",
      gate: "12",
      flightClass: "Economy",
    ),
  ];

  List<FlightModel> get filteredFlights {
    final list = [...flights];

    if (activeFilter == 0) {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (activeFilter == 1) {
      return list.where((e) => e.logoText != "CattyAir").toList();
    }

    return list;
  }

  void _selectFlight(int index) {
    setState(() => selectedIndex = index);

    final flight = filteredFlights[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlightDetailsScreen(flight: flight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredFlights;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
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

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopBar(
                      onBack: () => Navigator.pop(context),
                      onMore: () {},
                    ),
                    const SizedBox(height: 14),

                    _FilterRow(
                      activeIndex: activeFilter,
                      onTap: (i) => setState(() => activeFilter = i),
                    ),
                    const SizedBox(height: 14),

                    for (int i = 0; i < list.length; i++) ...[
                      _FlightCard(
                        flight: list[i],
                        onSelect: () => _selectFlight(i),
                      ),
                      if (i != list.length - 1) const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ),

            Positioned(
              right: 18,
              bottom: 24,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(999),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBFD7FF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 22,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.tune_rounded,
                    size: 22,
                    color: Colors.black.withOpacity(0.75),
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

// ===================== UI WIDGETS =====================

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onMore;

  const _TopBar({
    required this.onBack,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
          const Spacer(),
          const Text(
            "Flight result",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0E0F12),
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),
          _CircleButton(
            icon: Icons.more_horiz_rounded,
            onTap: onMore,
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

class _FilterRow extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _FilterRow({
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ["Lowest to Highest", "Preferred airlines", "Flight"];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final active = i == activeIndex;
          return InkWell(
            onTap: () => onTap(i),
            borderRadius: BorderRadius.circular(999),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF2B67FF) : Colors.white,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  if (!active)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : Colors.black.withOpacity(0.70),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback onSelect;

  const _FlightCard({
    required this.flight,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
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
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

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
              Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.06),
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

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$${flight.price}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2B67FF),
                    ),
                  ),
                  Text(
                    "/person",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.45),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: onSelect,
                borderRadius: BorderRadius.circular(999),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101114),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Select flight",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
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
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
          ),
        ),
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
