import 'package:credit_card_slider/card_background.dart';
import 'package:credit_card_slider/card_company.dart';
import 'package:credit_card_slider/card_network_type.dart';
import 'package:credit_card_slider/credit_card_widget.dart';
import 'package:credit_card_slider/validity.dart';
import 'package:flutter/material.dart';
import 'package:tablethings/models/stripe/card.dart' as Stripe;
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCardForm extends StatefulWidget {
  Stripe.Card card = Stripe.Card();
  String cardHolder = '';
  String cardNumber = '';

  CreditCardForm({
    Key key,
  });

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _cvvCodeController = TextEditingController();

  /// Get card type from its number
  CardNetworkType _getCardType(String number) {
    var type = detectCCType(number);

    if (type == CreditCardType.visa) {
      return CardNetworkType.visa;
    }

    if (type == CreditCardType.mastercard) {
      return CardNetworkType.mastercard;
    }

    return null;
  }

  void _updateCardValues() {
    widget.cardNumber = _cardNumberController.text;
    widget.cardHolder = _cardHolderNameController.text;
    widget.card = Stripe.Card(
      last4: _cardNumberController.text.substring(_cardNumberController.text.length - 4),
      expMonth: int.tryParse(_expiryMonthController.text),
      expYear: int.tryParse(_expiryYearController.text),
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _cardNumberController.addListener(_updateCardValues);
    _expiryMonthController.addListener(_updateCardValues);
    _expiryYearController.addListener(_updateCardValues);
    _cardHolderNameController.addListener(_updateCardValues);
    _cvvCodeController.addListener(_updateCardValues);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          CreditCard(
            cardBackground: SolidColorCardBackground(Colors.purple),
            cardNetworkType: _getCardType(widget.cardNumber),
            cardHolderName: widget.cardHolder,
            cardNumber: () {
              String cardNumber = '';

              for (int i = 0; i < widget.cardNumber.length; i++) {
                if (i > 0 && i % 4 == 0) {
                  cardNumber += ' ';
                }

                cardNumber += widget.cardNumber[i];
              }

              return cardNumber;
            }(),
            company: CardCompany.sbi,
            validity: () {
              if (widget.card.expYear == null || widget.card.expMonth == null) {
                return null;
              }

              return Validity(
                validThruMonth: widget.card.expMonth,
                validThruYear: widget.card.expYear,
              );
            }(),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '',
                    hintText: '0000 0000 0000 0000',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _cardHolderNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '',
                    hintText: 'Joni Pusenius',
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _expiryMonthController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '',
                    hintText: '06',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _expiryYearController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '',
                    hintText: '2021',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _cvvCodeController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '',
                    hintText: '314',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cardHolderNameController.dispose();
    _cardNumberController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    _cvvCodeController.dispose();
    super.dispose();
  }
}
