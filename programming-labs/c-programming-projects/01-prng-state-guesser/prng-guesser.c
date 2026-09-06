#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
    srand(time(0));
    int random_number = rand() % 100 + 1;

    int score = 10;
    int guess;
    printf("Guess the number between 1 and 100: ");
    for (int i = 1; i <= 10; i++)
    {
        scanf("%d", &guess);

        if (guess <= 100 && guess > 0)
        {
            if (i == 10 && guess != random_number)
            {
                printf("You have guess %d times\n", i);
                printf("Your score is %d\n", score - i);
                break;
            }
            else
            {
                if (guess == random_number)
                {
                    printf("Congratulations! you entered the correct number %d in %d guesses\n", random_number, i);
                    printf("Your score is %d out of %d\n", score - (i - 1), score);
                    break;
                }
                else if (guess < random_number)
                {
                    printf("Your Number %d is Smaller \n ", guess);
                    printf("You Guessed %d times: ", i);
                }
                else if (guess > random_number)
                {
                    printf("Your Number %d is Greater\n", guess);
                    printf("You Guessed %d times: ", i);
                }
            }
        }
        else
        {
            printf("Please Enter a number between 1 to 100: ");
            i--;
        }
    }

    return 0;
}
