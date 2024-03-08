import re

def validate_credit_card(card_number):
    pattern = r'^[456]\d{3}(-?\d{4}){3}$'

    if re.match(pattern, card_number):
        card_number = card_number.replace('-', '')
        if re.search(r'(\d)\1{3,}', card_number):
            return "Invalid"  
        else:
            return "Valid"    
    else:
        return "Invalid"
    
card_number = "5133-3367-8912-3456"
print(validate_credit_card(card_number))  
