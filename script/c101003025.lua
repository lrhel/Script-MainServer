--魔導獣 バジリスク
--Mythical Beast Basilisk
--Script by nekrozar
function c101003025.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x1)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101003025,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,101003025)
	e1:SetCondition(c101003025.tdcon)
	e1:SetTarget(c101003025.tdtg)
	e1:SetOperation(c101003025.tdop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c101003025.acop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101003025,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101003125)
	e4:SetCost(c101003025.thcost)
	e4:SetTarget(c101003025.thtg)
	e4:SetOperation(c101003025.thop)
	c:RegisterEffect(e4)
end
c101003025.spell_counter_permit=99
function c101003025.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
end
function c101003025.tdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and not c:IsCode(101003025) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c101003025.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable()
		and Duel.IsExistingMatchingCard(c101003025.tdfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101003025.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c101003025.tdfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c101003025.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c101003025.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x209) and c:IsAbleToHand()
		and (c:GetSequence()>5 or not c:IsLocation(LOCATION_SZONE))
end
function c101003025.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,3,REASON_COST)
end
function c101003025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101003025.thfilter,tp,LOCATION_SZONE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE+LOCATION_EXTRA)
end
function c101003025.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c101003025.thfilter,tp,LOCATION_SZONE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
