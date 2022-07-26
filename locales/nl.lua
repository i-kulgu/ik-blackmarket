local Translations = {
    error = {
        incorrect_amount = "Onjuist aantal",
        no_space = "Niet genoeg ruimte in inventaris",
        no_slots = "Niet genoeg slots in inventaris",
        no_money = "Niet genoeg geld",
        cant_give = "Kan item niet geven!",
    },
    target = {
        browse = "Winkel Bekijken",
    },
    menu = {
        close = "❌ Sluiten",
        cost = "Kosten: $",
        weight = "Gewicht:",
        confirm = "Bevestig aankoop",
        cpi = "Kosten per stuk:",
        payment_type = "Betalingswijze",
        cash = "Cash",
        card = "Kaart",
        amount = "Te kopen aantal",
        submittext = "Betalen",
        blackmoney = "Zwart Geld",
        crypto = "Q-Bit",
     }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
