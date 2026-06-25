import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_data/services/terminology_service.dart';
import 'package:cc_core/constants/app_spacing.dart';

typedef OnDiagnosisSelected = void Function(String code, String displayName);

class DiagnosisSearch extends StatefulWidget {
  final OnDiagnosisSelected onSelected;
  final String hintText;
  final double? maxResultsHeight;

  const DiagnosisSearch({super.key, required this.onSelected, this.hintText = 'Search diagnosis...', this.maxResultsHeight});

  @override
  State<DiagnosisSearch> createState() => _DiagnosisSearchState();
}

class _DiagnosisSearchState extends State<DiagnosisSearch> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<(String, String)> _results = [];
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _showResults = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text;
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _showResults = false;
      });
      return;
    }
    setState(() {
      _results = TerminologyService.searchICD10(query);
      _showResults = _results.isNotEmpty;
    });
  }

  void _clearSearch() {
    _controller.clear();
    _focusNode.unfocus();
    setState(() {
      _results = [];
      _showResults = false;
    });
  }

  void _selectResult(String code, String displayName) {
    widget.onSelected(code, displayName);
    _clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          placeholder: Text(widget.hintText, style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
          onChanged: (_) => _onSearchChanged(),
          onTap: () {
            if (_controller.text.trim().isNotEmpty) {
              setState(() => _showResults = true);
            }
          },
        ),

        if (_showResults && _results.isNotEmpty)
          Container(
            constraints: BoxConstraints(maxHeight: widget.maxResultsHeight ?? 280),
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.border.withValues(alpha: 0.5)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _results.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = _results[index];
                final displayName = item.$1;
                final code = item.$2;
                return GestureDetector(
                  onTap: () => _selectResult(code, displayName),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            code,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.primary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            displayName,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.foreground),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        if (_showResults && _results.isEmpty && _controller.text.trim().isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.border.withValues(alpha: 0.5)),
            ),
            child: Center(
              child: Text('No matching diagnoses found', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
            ),
          ),
      ],
    );
  }
}
