import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/bottom_nav.dart';
import 'package:flutter_application_1/Screens/flight_result.dart';
import 'package:provider/provider.dart';

import '../providers/airport_provider.dart';

class TripHomeScreen extends StatefulWidget {
  const TripHomeScreen({super.key});

  @override
  State<TripHomeScreen> createState() => _TripHomeScreenState();
}

class _TripHomeScreenState extends State<TripHomeScreen> {
  String? fromCode;
  String? toCode;

  DateTime selectedDate = DateTime.now().add(const Duration(days: 2));
  int people = 1;

  int bottomIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final p = context.read<AirportProvider>();

      await p.loadDepartureAirports();
      await p.loadArrivalAirports();

      // Auto select first values (so dropdown never crashes)
      if (mounted) {
        if (p.departureAirports.isNotEmpty) {
          fromCode = (p.departureAirports.first["airport_code"] ?? "").toString();
        }
        if (p.arrivalAirports.isNotEmpty) {
          toCode = (p.arrivalAirports.first["airport_code"] ?? "").toString();
        }
        setState(() {});
      }
    });
  }

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

  String _formatApiDate(DateTime d) {
    final y = d.year.toString().padLeft(4, "0");
    final m = d.month.toString().padLeft(2, "0");
    final day = d.day.toString().padLeft(2, "0");
    return "$y-$m-$day";
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
      final t = fromCode;
      fromCode = toCode;
      toCode = t;
    });
  }

  void _searchFlights() {
    if (fromCode == null || toCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select From & To airport")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlightResultScreen(
          fromCity: fromCode!, // IMPORTANT: code only
          toCity: toCode!, // IMPORTANT: code only
          date: DateTime.parse(_formatApiDate(selectedDate)),
          people: people,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final airportProvider = context.watch<AirportProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
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

                    if (airportProvider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    if (airportProvider.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          airportProvider.error!,
                          style: TextStyle(
                            color: Colors.red.withOpacity(0.85),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                    _SearchCard(
                      fromCode: fromCode,
                      toCode: toCode,
                      fromList: airportProvider.departureAirports,
                      toList: airportProvider.arrivalAirports,
                      dateText: _formatDate(selectedDate),
                      people: people,
                      onSwap: _swapFromTo,
                      onPickDate: _pickDate,
                      onFromChanged: (v) => setState(() => fromCode = v),
                      onToChanged: (v) => setState(() => toCode = v),
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
                        itemBuilder: (_, i) => _TicketSavedTrip(index: i),
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
  final String? fromCode;
  final String? toCode;

  final List<Map<String, dynamic>> fromList;
  final List<Map<String, dynamic>> toList;

  final String dateText;
  final int people;

  final VoidCallback onSwap;
  final VoidCallback onPickDate;

  final ValueChanged<String?> onFromChanged;
  final ValueChanged<String?> onToChanged;

  final ValueChanged<int> onPeopleChanged;
  final VoidCallback onSearch;

  const _SearchCard({
    required this.fromCode,
    required this.toCode,
    required this.fromList,
    required this.toList,
    required this.dateText,
    required this.people,
    required this.onSwap,
    required this.onPickDate,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onPeopleChanged,
    required this.onSearch,
  });

  String _label(Map<String, dynamic> a) {
    final city = (a["city"] ?? "").toString();
    final code = (a["airport_code"] ?? "").toString();
    return "$city ($code)";
  }

  List<Map<String, dynamic>> _uniqueByCode(List<Map<String, dynamic>> list) {
    final map = <String, Map<String, dynamic>>{};
    for (final e in list) {
      final code = (e["airport_code"] ?? "").toString();
      if (code.isEmpty) continue;
      map[code] = e;
    }
    return map.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final safeFromList = _uniqueByCode(fromList);
    final safeToList = _uniqueByCode(toList);

    final fromCodes = safeFromList.map((e) => (e["airport_code"] ?? "").toString()).toList();
    final toCodes = safeToList.map((e) => (e["airport_code"] ?? "").toString()).toList();

    final safeFromValue = fromCodes.contains(fromCode) ? fromCode : null;
    final safeToValue = toCodes.contains(toCode) ? toCode : null;

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
                  const SizedBox(height: 6),

                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: safeFromValue,
                      isExpanded: true,
                      hint: const Text("Select departure"),
                      items: safeFromList.map((a) {
                        final code = (a["airport_code"] ?? "").toString();
                        return DropdownMenuItem(
                          value: code,
                          child: Text(_label(a)),
                        );
                      }).toList(),
                      onChanged: safeFromList.isEmpty ? null : onFromChanged,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Divider(height: 1, thickness: 1, color: Colors.black.withOpacity(0.06)),
                  const SizedBox(height: 12),

                  const _Label("To"),
                  const SizedBox(height: 6),

                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: safeToValue,
                      isExpanded: true,
                      hint: const Text("Select destination"),
                      items: safeToList.map((a) {
                        final code = (a["airport_code"] ?? "").toString();
                        return DropdownMenuItem(
                          value: code,
                          child: Text(_label(a)),
                        );
                      }).toList(),
                      onChanged: safeToList.isEmpty ? null : onToChanged,
                    ),
                  ),

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
class _TicketSavedTrip extends StatelessWidget {
  final int index;
  const _TicketSavedTrip({required this.index});

  @override
  Widget build(BuildContext context) {
    final airlines = ["Citilink", "IndiGo", "Air India"];
    final from = ["CGK", "DEL", "BOM"];
    final to = ["NRT", "BBI", "VTZ"];
    final times = [
      ["07:47", "14:30"],
      ["09:10", "12:55"],
      ["18:30", "22:20"],
    ];

    final dates = ["Jan 20, 2025", "Feb 12, 2025", "Mar 05, 2025"];

    final a = airlines[index % airlines.length];
    final f = from[index % from.length];
    final t = to[index % to.length];

    final depart = times[index % times.length][0];
    final arrive = times[index % times.length][1];
    final date = dates[index % dates.length];

    return Container(
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
          Text(
            a,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0D8B57),
              fontStyle: FontStyle.italic,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SavedAirportSide(time: depart, code: f, city: "(City)"),

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
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.flight_takeoff_rounded,
                      size: 20,
                      color: _C.blue.withOpacity(0.9),
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

              _SavedAirportSide(time: arrive, code: t, city: "(City)"),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ dashed line
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _DottedDivider(
              color: Colors.black.withOpacity(0.18),
              dashWidth: 5,
              dashSpace: 5,
            ),
          ),

          const SizedBox(height: 12),

          // ✅ Date row
          Row(
            children: [
              _SavedDateBlock(date: date, alignEnd: false),
              const Spacer(),
              _SavedDateBlock(date: date, alignEnd: true),
            ],
          ),
        ],
      ),
    );
  }
}class _SavedDateBlock extends StatelessWidget {
  final String date;
  final bool alignEnd;

  const _SavedDateBlock({
    required this.date,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        const Text(
          "DATE",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Color(0xFF9AA2B1),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          date,
          style: const TextStyle(
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
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

class _SavedAirportSide extends StatelessWidget {
  final String time;
  final String code;
  final String city;

  const _SavedAirportSide({
    required this.time,
    required this.code,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
