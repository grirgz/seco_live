
(
	~play_game = { arg n=2, rec=3800;
		if(rec >= 0) {
			if(0.5.coin) {
				//(2**n).debug("win!");
				2*~play_game.(n+1, rec-1)
			} {
				//debug("loose");
				2
			}
		} {
			2
		}
   
	}
)
~play_game.();

(
~solve_debt = {
	if(~bank.money > ~bank.credit) {
		~bank.credit.debug("paid credit!");
		~bank.money = ~bank.money - ~bank.credit;
		~bank.credit = 0;
	};
	if(~bank.money > ~bank.bankroute) {
		~bank.bankroute.debug("paid bankroute!");
		~bank.money = ~bank.money - ~bank.bankroute;
		~bank.bankroute = 0;
	} {
		~bank.money.debug("sent all money to bankroute!");
		~bank.bankroute = ~bank.bankroute - ~bank.money;
		~bank.money = 0;
	};
}
)
~solve_debt.()

	~bank = (money:5000);
(
	~bank.starting_money = ~bank.money;
	5000.do {

		~agent = ();
		~agent.starting_money = rrand(200,200000);
		~agent.money = ~agent.starting_money;
		//~agent.money.debug("========== NEW AGENT");
		if(~bank.money < 0) {
			var cred = ~bank.money.neg;
			~bank.credit = (~bank.credit ? 0) + cred;
			~bank.money = (~bank.money ? 0) + cred;
			"new credit: %.  credit amount: %".format(cred, ~bank.credit);
		};
		if(~bank.money <= 0) {
			var cred = 10000;
			~bank.credit = (~bank.credit ? 0) + cred;
			~bank.money = (~bank.money ? 0) + cred;
			"new credit: %.  credit amount: %".format(cred, ~bank.credit);
		};
		~price = 113;
		1000.do {
			block { arg break;
				var result;
				if(~agent.money < ~price or: {~bank.money <= 0}) {
					break.value;
				};
				~agent.money = ~agent.money - ~price;
				~bank.money = ~bank.money + ~price;
				result = ~play_game.();
				//result.debug("result");
				if(~bank.money < result) {
					result.debug("*** bankroute! ***");
					~bank.bankroute = (~bank.bankroute ? 0) + (result - ~bank.money);
					~bank.money = 0;
					~agent.money = ~agent.money + result;
				} {
					~agent.money = ~agent.money + result;
					~bank.money = ~bank.money - result;
				};
			};
		};
		//"===== agent money: %.  agent result: %.  bank result:%.  bank:%".format(~agent.money, ~agent.money - ~agent.starting_money, ~bank.money - ~bank.starting_money, ~bank).postln;
		~agent.money;
	};
	~bank.money = ~bank.money - (~bank.credit * 0.07).debug("paid interet");
	if(~bank.money > ~bank.credit) {
		~solve_debt.();
	};
	"***** agent money: %.  agent result: %.  bank result:%.  bank:%".format(~agent.money, ~agent.money - ~agent.starting_money, ~bank.money - ~bank.starting_money, ~bank).postln;

)
~play_game.();
