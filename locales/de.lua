local Translations = {
    error = {
        incorrect_amount = "Falscher Betrag",
        no_space = "Nicht genug Platz im Inventar",
        no_slots = "Nicht genügend Slots im Inventar",
        no_money = "Nicht genug Geld",
        cant_give = "Item kann nicht gegeben werden!",
    },
    target = {
        browse = "Shop durchsuchen",
    },
    menu = {
        close = "❌ schliessen",
        cost = "Preis: $",
        weight = "Gewicht:",
        confirm = "Kauf bestätigen",
        cpi = "Preis pro Item:",
        payment_type = "Zahlungsart",
        cash = "Bargeld",
        card = "Karte",
        amount = "Zu kaufender Betrag",
        submittext = "Kaufen",
        blackmoney = "Schwarzgeld",
        crypto = "Q-Bit",
     }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
