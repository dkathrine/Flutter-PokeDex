import 'package:flutter/material.dart';
import 'package:pokedex/common/utils/type_assets.dart';

class TypeFilterButton extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String?> onSelected;
  final double size;

  const TypeFilterButton({
    super.key,
    required this.selectedType,
    required this.onSelected,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final display = selectedType;
    return GestureDetector(
      onTap: () async {
        // hide keyboard if open
        FocusScope.of(context).unfocus();

        final result = await showModalBottomSheet<String?>(
          context: context,
          isScrollControlled: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) {
            return _TypePickerSheet(selected: selectedType);
          },
        );

        // result is either a type string or null (if user picked All or cancelled)
        if (result != null || result == null) {
          // we always call to update even if null (meaning "All")
          onSelected(result);
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: selectedType == null ? Colors.transparent : Colors.black12,
            width: selectedType == null ? 0 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildIcon(display),
        ),
      ),
    );
  }

  Widget _buildIcon(String? type) {
    if (type == null) {
      // show a simple filter icon for "All"
      return const Icon(Icons.filter_list, size: 24, color: Colors.black54);
    }
    final path = assetPathForType(type);
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (ctx, err, st) =>
          const Icon(Icons.help_outline, color: Colors.black54),
    );
  }
}

class _TypePickerSheet extends StatelessWidget {
  final String? selected;
  const _TypePickerSheet({this.selected});

  @override
  Widget build(BuildContext context) {
    final types = kPokemonTypes;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 320,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filter by Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Choose "All" -> returns null
                      Navigator.of(context).pop(null);
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    // optional first tile to represent "All" as an icon tile
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(null),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Color(0xFFF0F0F0),
                            child: Icon(Icons.clear, color: Colors.black54),
                          ),
                          SizedBox(height: 8),
                          Text('All', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    // types
                    ...types.map((t) {
                      final path = assetPathForType(t);
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pop(t),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: selected == t
                                  ? Colors.black12
                                  : const Color(0xFFF6F6F6),
                              child: Image.asset(
                                path,
                                width: 36,
                                height: 36,
                                fit: BoxFit.contain,
                                errorBuilder: (ctx, e, st) =>
                                    const Icon(Icons.help_outline),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(t, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    }),
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
