import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/backgroundWrapper.dart';
import 'package:polka_wallet/common/components/topTaps.dart';
import 'package:polka_wallet/common/consts/settings.dart';
import 'package:polka_wallet/page/governance/treasury/spendProposals.dart';
import 'package:polka_wallet/page/governance/treasury/tips.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class TreasuryPage extends StatefulWidget {
  TreasuryPage(this.store);

  static const String route = '/gov/treasury/index';

  final AppStore store;

  @override
  _TreasuryPageState createState() => _TreasuryPageState();
}

class _TreasuryPageState extends State<TreasuryPage> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      webApi.gov.fetchCouncilInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).gov;
    var tabs = [dic['treasury'], dic['treasury.tip']];
    bool isKusama =
        widget.store.settings.endpoint.info == networkEndpointKusama.info;
    String imageColor = isKusama ? 'black' : 'pink';
    return BackgroundWrapper(
      AssetImage("assets/images/staking/top_bg_$imageColor.png"),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).cardColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TopTabs(
                      names: tabs,
                      activeTab: _tab,
                      onTab: (v) {
                        setState(() {
                          if (_tab != v) {
                            _tab = v;
                          }
                        });
                      },
                    ),
                  ],
                ),
                Observer(
                  builder: (_) {
                    return Expanded(
                      child: widget.store.gov.council.members == null
                          ? CupertinoActivityIndicator()
                          : _tab == 0
                              ? SpendProposals(widget.store)
                              : MoneyTips(widget.store),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
