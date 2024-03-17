name = input("Enter your name")
weight = int(input("Enter your weight in pounds: "))
height = int(input("Enter your height in inches: "))

BMI = (weight * 703) / (height * height)

print(BMI)

if BMI > 0:
    if(BMI<18.5):
        print(name + ", you are Underweight")
    elif(BMI<=24.9):
        print(name + ", you are Normal Weight")
    elif(BMI<=29.9):
        print(name + ", you are Overweight")
    elif(BMI<=34.9):
        print(name + ", you are Obese")
    elif(BMI<=39.9):
        print(name + ", you are Severely Obese")
    else:
        print(name + ", you are Morbidly Obese")
else:
    print("Enter valid input")

