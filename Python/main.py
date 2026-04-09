# Minutes into Human Readable Form

Time_in_minutes=int(input("Enter the time in minutes: "))
Hours=Time_in_minutes//60; # Divisor
Minutes=Time_in_minutes%60; # Remainder
print(f"{Hours} Hours {Minutes} Minutes")


# Removing duplicates and Print unique values

Text= input("Enter the text: ")
unique_value=""
for ch in Text:
    if ch not in unique_value:
        unique_value+=ch
print(unique_value)