{-# LANGUAGE NumericUnderscores #-}

----

yearsTillWrittenOff = 30

----

rpi = 0.026

maxAdditionalInterest = 0.03

repaymentRate = 0.09

salaryIncreaseRate = 0.05

----

repaymentThreshold = 27_295

higherInterestThreshold = 49_130

initialDebt = 42_478

---

type Debt = Float

type Earnings = Float

type Payment = Float

type YearData = (Debt, Earnings, Payment)

initialYearData :: Earnings -> YearData
initialYearData initialSalary = (initialDebt, initialSalary, debtRepayment initialDebt initialSalary)

debtRepayment :: Debt -> Earnings -> Payment
debtRepayment debt earnings = min debt (max 0 repayment)
  where
    repayment = (earnings - repaymentThreshold) * repaymentRate

additionalInterest :: Earnings -> Float
additionalInterest earnings = min maxAdditionalInterest (max 0 additionalInterest)
  where
    additionalInterestSlope = maxAdditionalInterest / (higherInterestThreshold - repaymentThreshold)
    additionalInterest = additionalInterestSlope * (earnings - repaymentThreshold)

nextYearData :: YearData -> YearData
nextYearData (debt, earnings, payment) = (debt', earnings', debtRepayment debt' earnings')
  where
    debt' = (debt - payment) * (1 + rpi + additionalInterest earnings')
    earnings' = earnings * (1 + salaryIncreaseRate)

run :: Earnings -> [YearData]
run initialSalary = take yearsTillWrittenOff (iterate nextYearData (initialYearData initialSalary))

totalPaid :: Earnings -> Payment
totalPaid initialSalary = sum (map (\(_, _, p) -> p) (run initialSalary))
