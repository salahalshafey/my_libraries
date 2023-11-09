import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../classes/pair_class.dart';

/// it can be used to render text with clickable links, phone numbers and email addresses. 

class LinkifyText extends StatelessWidget {
  const LinkifyText({
    required this.text,
    required this.style,
    required this.textAlign,
    required this.textDirection,
    required this.linkStyle,
    required this.onOpen,
    Key? key,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextDirection textDirection;
  final TextStyle linkStyle;
  final void Function(String link, TextType linkType) onOpen;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: getLinksInText(text).map((inlineText) {
          if (inlineText.second == TextType.normal) {
            return TextSpan(
              text: inlineText.first,
              style: style,
            );
          } else {
            return TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => onOpen(inlineText.first, inlineText.second),
              text: inlineText.first,
              style: linkStyle,
            );
          }
        }).toList(),
      ),
      textAlign: textAlign,
      textDirection: textDirection,
    );
  }
}

/// it can be used to render text with clickable links, phone numbers and email addresses. 
/// this text also can be selected and copied.

class SelectableLinkifyText extends StatelessWidget {
  const SelectableLinkifyText({
    required this.text,
    required this.style,
    this.textAlign,
    required this.textDirection,
    required this.linkStyle,
    required this.onOpen,
    Key? key,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextDirection textDirection;
  final TextStyle linkStyle;
  final void Function(String link, TextType linkType) onOpen;

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: getLinksInText(text).map((inlineText) {
          if (inlineText.second == TextType.normal) {
            return TextSpan(
              text: inlineText.first,
              style: style,
            );
          } else {
            return TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => onOpen(inlineText.first, inlineText.second),
              text: inlineText.first,
              style: linkStyle,
            );
          }
        }).toList(),
      ),
      textAlign: textAlign,
      textDirection: textDirection,
    );
  }
}

/// This function extracts links, emails, and Egyptian phone numbers from a given text
/// and returns them as a list of Pair objects with their respective TextType.
/// * time complexity of the function is O(n + m log m). 
/// * space complexity is O(n + m).
/// where n is the length of the input string and m is the number of matches links.

List<Pair<String, TextType>> getLinksInText(String text) {
  // Define regular expressions for URLs, emails, and Egyptian phone numbers.
  final urlMatcher = RegExp(
      r"(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})");
  final emailMatcher = RegExp(r"[a-z0-9]+@[a-z]+\.[a-z]{2,3}");
  final egyptPhoneNumberMatcher = RegExp(r"01[0125][0-9]{8}");

  // Create an empty list to hold all the matches.
  List<Pair<Match, TextType>> allMatches = [];
  
  // Create a copy of the original text to preserve it.
  String myText = text;

  // Find all URL matches in the text and add them to the allMatches list.
  final urlMatches = urlMatcher
      .allMatches(myText)
      .map((urlMatch) => Pair(urlMatch, TextType.url));
  allMatches.addAll(urlMatches);
  
  // Replace all URL matches with an empty string to remove them from myText.
  myText = myText.replaceAllMapped(
      urlMatcher, (match) => ''.padLeft(match.end - match.start));

  // Find all email matches in the updated myText and add them to the allMatches list.
  final emailMatches = emailMatcher
      .allMatches(myText)
      .map((emailMatch) => Pair(emailMatch, TextType.email));
  allMatches.addAll(emailMatches);
  
  // Replace all email matches with an empty string to remove them from myText.
  myText = myText.replaceAllMapped(
      emailMatcher, (match) => ''.padLeft(match.end - match.start));

  // Find all Egyptian phone number matches in the updated myText and add them to the allMatches list.
  final phoneMatches = egyptPhoneNumberMatcher
      .allMatches(myText)
      .map((phoneMatch) => Pair(phoneMatch, TextType.phoneNumber));
  allMatches.addAll(phoneMatches);

  // Sort the list of matches in order of appearance in the text.
  allMatches.sort((p1, p2) => p1.first.start.compareTo(p2.first.start));

  // Create an empty list to hold the final links with their TextType.
  List<Pair<String, TextType>> links = [];

  // Iterate over all matches in the allMatches list.
  int i = 0;
  for (final match in allMatches) {
    // Add the text between the previous match and the current match as a normal link.
    links.add(Pair(
      text.substring(i, match.first.start),
      TextType.normal,
    ));

    // Add the current match as a link with its respective TextType.
    links.add(Pair(
      text.substring(match.first.start, match.first.end),
      match.second,
    ));

    // Update the index to the end of the current match.
    i = match.first.end;
  }

  // Add the remaining text as a normal link.
  links.add(Pair(
    text.substring(i),
    TextType.normal,
  ));

  return links;
}

enum TextType {
  url,
  phoneNumber,
  email,
  normal,
}
