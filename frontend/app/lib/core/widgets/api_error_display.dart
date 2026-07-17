// T172 (Phase 4 walkthrough finding #4): Flutter web's canvas-based text
// rendering makes plain Text widgets uncopyable by default — every screen's
// error message rendered this way, uncopyable, exactly the finding this
// task fixes. SelectionArea makes the message genuinely selectable/copyable
// like any other web text; the explicit copy button is a more discoverable,
// reliable alternative to drag-selection (touch web, some browsers) that
// copies the SAME text shown on screen — which already carries the
// correlation ID inline when one is present (T170's describeIdentityError),
// so one tap copies the exact failure + reference a support/walkthrough
// report needs, per this task's own wording.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApiErrorDisplay extends StatelessWidget {
  const ApiErrorDisplay({super.key, required this.message, this.messageKey});

  /// The error text to display and copy — already includes the correlation
  /// ID inline when one is present (see describeIdentityError, T170).
  final String message;

  /// The Key the message text itself carries — preserves each screen's
  /// existing `find.byKey`/`find.text` test conventions across the T172
  /// refactor (e.g. `registerErrorMessage`).
  final Key? messageKey;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: message));
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(MaterialLocalizations.of(context).copyButtonLabel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              message,
              key: messageKey,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          IconButton(
            key: const Key('apiErrorCopyButton'),
            icon: const Icon(Icons.copy_outlined, size: 18),
            tooltip: MaterialLocalizations.of(context).copyButtonLabel,
            onPressed: () => _copy(context),
          ),
        ],
      ),
    );
  }
}
