local Translations = {
    error = {
        incorrect_amount = "Quantidade Incorreta",
        no_space = "Sem Espaço Suficiente no Inventário",
        no_slots = "Sem Slots Suficientes no Inventário",
        no_money = "Sem Dinheiro Suficiente",
        cant_give = "Não Posso te dar o Item!",
        not_enough_item = "There is not enough of this item amount!"
    },
    target = {
        browse = "Navegar pela Loja",
    },
    menu = {
        close = "❌ Fechar",
        cost = "Custo: $",
        weight = "Peso:",
        confirm = "Confirmar Compra",
        cpi = "Custo por Item:",
        payment_type = "Tipo do Pagamento",
        cash = "Dinheiro",
        card = "Cartão",
        amount = "Quantidade para Comprar",
        submittext = "Pagar",
        blackmoney = "Dinheiro Sujo",
        crypto = "Q-Bit",
        amt = "Amount: "
     }
}
if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
