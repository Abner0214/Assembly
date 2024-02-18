#include <stdio.h>

// Function to calculate the Least Common Multiple (LCM)
int lcm(int a, int b) {
    int tempA = a, tempB = b;

    // Calculate GCD without recursion
    while (tempB != 0) {
        int temp = tempB;
        tempB = tempA % tempB;
        tempA = temp;
    }

    // LCM * GCD = |a * b|
    return (a / tempA) * b;
}

int main() {
    int num1, num2;

    // Input two numbers
    printf("Enter two numbers: ");
    scanf("%d %d", &num1, &num2);

    // Calculate and display the LCM
    printf("LCM of %d and %d is %d\n", num1, num2, lcm(num1, num2));

    return 0;
}
