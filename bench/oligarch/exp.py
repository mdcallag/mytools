"""
Copyright (c) 2019, Mark Callaghan
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"""

import argparse
import sys
import random

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('--budget', type=int, default=100,
                      help='Amount of money to start with')
  parser.add_argument('--bankrupt_at', type=int, default=10,
                      help='User is bankrupt when budget drops to this amount '\
                           'or the budget is less than the fixed bet amount')
  parser.add_argument('--bet_percent', type=float, default=10.0,
                      help='Amount to bet when percentage betting enabled. '\
                           'The bet amount is this percentage of the minimum '\
                           'of the budgets.')
  parser.add_argument('--bet_min', type=int, default=1,
                      help='Minimum bet. Used with --bet_percent')
  parser.add_argument('--bet_fixed', type=int, default=10,
                      help='Bet is fixed at this amount when fixed betting enabled.')
  parser.add_argument('--num_games', type=int, default=1000,
                      help='Number of games to play. Game ends from bankruptcy or '
                           'reaching max_rounds')
  parser.add_argument('--max_rounds', type=int, default=1000,
                      help='Max number of games (bets) to play each round')
  parser.add_argument('--bet_style', choices=['fixed', 'percent'])
  parser.add_argument('--win_percent', type=float, default=20.0,
                      help='Gain this percent of your bet on win.')
  parser.add_argument('--lose_percent', type=float, default=20.0,
                      help='Lose this percent of your bet on loss.')
  parser.add_argument('--debug', type=int, default=0,
                      help='Set to 1 to get more output')

  args = parser.parse_args()

  if args.budget <= 0:
    print('--budget must be > 0')
    sys.exit(-1)
  elif args.bet_percent <= 0:
    print('--bet_percent must be > 0')
    sys.exit(-1)
  elif args.bet_fixed <= 0:
    print('--bet_fixed must be > 0')
    sys.exit(-1)
  elif args.bet_min <= 0:
    print('--bet_min must be > 0')
    sys.exit(-1)
  elif args.num_games <= 0:
    print('--num_games must be > 0')
    sys.exit(-1)
  elif args.max_rounds <= 0:
    print('--max_rounds must be > 0')
    sys.exit(-1)
  elif args.win_percent <= 0:
    print('--win_percent must be > 0')
    sys.exit(-1)
  elif args.lose_percent <= 0:
    print('--lose_percent must be > 0')
    sys.exit(-1)

  if args.bet_style == 'fixed':
    do_fixed(args)
  else:
    do_percent(args)

def do_fixed(args):
  do_games(args, lambda b : args.bet_fixed)

def do_percent(args):
  do_games(args, lambda b : (args.bet_percent / 100.0) * b)

def do_games(args, bet_fn):
  num_bankrupt = 0
  num_max = 0
  rounds_bankrupt = 0
  total_gain = 0
  total_rounds = 0

  for i in range(args.num_games):
    r, w, b = do_game(args, bet_fn)
    budget_diff = b - args.budget
    total_gain += budget_diff
    total_rounds += r

    if r < args.max_rounds:
      num_bankrupt += 1
      rounds_bankrupt += r
      if args.debug: print('Outcome: bankrupt at round %d with %d wins' % (r, w))
    else:
      num_max += 1
      if args.debug: print('Outcome: stop after max rounds with %d wins' % w)

  avg_gain_per_game = total_gain / args.num_games
  avg_gain_per_round = total_gain / total_rounds

  print('%d total, %.1f pct bankrupt, avg gain: %.3f game, %.5f bet' % (
        args.num_games, (100.0 * num_bankrupt) / args.num_games,
        avg_gain_per_game, avg_gain_per_round))

  # avg_rounds_bankrupt = 0.0
  # if num_bankrupt > 0: avg_rounds_bankrupt = rounds_bankrupt / float(num_bankrupt)

def do_game(args, bet_fn):
  budget = args.budget

  rounds = 0
  wins = 0

  win_frac = args.win_percent / 100.0
  lose_frac = args.lose_percent / 100.0

  while budget > args.bankrupt_at and rounds <= args.max_rounds:
    # Bet that player is will to make
    bet = bet_fn(budget)
    if bet < args.bet_min: bet = args.bet_min

    result = random.randint(1, 2)
    if result == 1:
      # player wins
      wins += 1
      diff = bet * win_frac
      budget += diff
      if args.debug: print('Win %.1f to %.1f from %.1f bet' % (diff, budget, bet))
    else:
      # player loses
      diff = bet * lose_frac
      budget -= diff
      if args.debug: print('Lose %.1f to %.1f from %.1f bet' % (diff, budget, bet))

    rounds += 1

  return rounds, wins, budget

if __name__ == "__main__":
    main()
