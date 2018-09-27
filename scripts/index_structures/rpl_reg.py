import argparse
import sys
import math
import numpy
import random
import pandas as pd
from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score
import matplotlib.pyplot as plt

def plot_it(actual, predicted, name, xarr, show, save):
  plt.scatter(xarr, actual, color='black', label='Actual')
  plt.scatter(xarr, predicted, color='blue', label='Predicted')
  plt.title('Predict %s with linear regression' % name)
  plt.ylabel(name)
  plt.xlabel('configuration#')
  plt.legend()
  plt.xlim(xmin=0)
  plt.ylim(ymin=0)
  if show:
    plt.show()
  if save:
    plt.savefig('%s.png' % name)
  plt.close('all')

def augment_combine(args, df, aug_cols):
  if args.augment:
    df['Nlvls_pow'] = numpy.power([2 for x in range(len(df['Nlvls']))], df['Nlvls'])
    for c in aug_cols:
      df[c + '_sq'] = df[c] * df[c]
      df[c + '_sqrt'] = numpy.sqrt(df[c])
      df[c + '_log'] = numpy.log2(df[c])

  if args.combine:
    for c1 in aug_cols:
      for c2 in aug_cols:
        if c1 != c2:
          # print('%s X %s' % (c1, c2))
          df[c1 + '_X_' + c2] = df[c1] * df[c2]

def get_model(args):
  if args.model == 'linear':
    return linear_model.LinearRegression(normalize=args.normalize)
  elif args.model == 'ridge':
    return linear_model.Ridge(normalize=args.normalize, alpha=args.alpha)
  else:
    print('model not supported: %s' % args.model)
    sys.exit(-1)

def runit(args):
  train_dfs = []
  for f in args.train.split(','):
    print('train: %s' % f)
    df = pd.read_table(f)
    train_dfs.append(df)
  train_df = pd.concat(train_dfs)
  print('before move %d train' % train_df.count()['L'])

  if args.test != None:
    test_dfs = []
    for f in args.test.split(','):
      print('test: %s' % f)
      df = pd.read_table(f)
      test_dfs.append(df)
    test_df = pd.concat(test_dfs)
  else:
    if args.train_pct >= 100 or args.train_pct < 1:
      print('train_pct=%d and must be >= 1 and < 100' % args.train_pct)
      sys.exit(-1)

    test_df = pd.DataFrame(columns=train_df.columns.copy())
    df_len = train_df.count()['L']
    n_to_move = int(((100 - args.train_pct) / 100.0) * df_len)
    to_move = []
    print('Move %d with train_pct=%d' % (n_to_move, args.train_pct))
    ixa = range(df_len)
    for x in range(n_to_move):
      v = random.choice(ixa)
      ixa.remove(v)
      to_move.append(v)  
    print('Moving: %s' % to_move)
    rows = [train_df.iloc[x].copy() for x in to_move]
    test_df = test_df.append(rows, ignore_index=True)
    train_df.drop(to_move, axis=0, inplace=True)

  if args.max_runs > 0:
    test_df = test_df[ test_df['Nruns'] <= args.max_runs]
    train_df = train_df[ train_df['Nruns'] <= args.max_runs]

  train_count = train_df.count()['L']
  test_count = test_df.count()['L']
  print('begin with %d train, %d test' % (train_count, test_count))

  if args.notdom:
    train_df = train_df[ train_df['isdom'] == False ]
    test_df = test_df[ test_df['isdom'] == False ]

  train_y = {}
  test_y = {}
  for cn in ['wa-I', 'wa-C', 'ph', 'rs', 'rn', 'L', 'C', 'isdom']:
    train_y[cn] = train_df[cn].copy()
    test_y[cn] = test_df[cn].copy()

  train_df.drop(['wa-I', 'wa-C', 'ph', 'pm', 'rs', 'rn', 'L', 'C', 'isdom'], axis=1, inplace=True)
  test_df.drop(['wa-I', 'wa-C', 'ph', 'pm', 'rs', 'rn', 'L', 'C', 'isdom'], axis=1, inplace=True)

  train_df.F = train_df.F.astype('category').cat.codes
  test_df.F = test_df.F.astype('category').cat.codes

  print(train_df.head())
  print(test_df.head())
  f1 = len(train_df.columns)

  aug_cols = ['sa', 'ca', 'Nruns', 'Nlvls']
  augment_combine(args, train_df, aug_cols)
  augment_combine(args, test_df, aug_cols)

  f3 = len(train_df.columns)
  print('features: %d initial, %d post augment+combine' % (f1, f3))
  print(train_df.columns)

  pdict = {}
  for cname in ['wa-I', 'wa-C', 'ph', 'rs']:
    lr = get_model(args)
    lr.fit(train_df, train_y[cname])
    pdict[cname] = lr.predict(test_df)
    print(cname)
    print("  mean squared error: %s" % mean_squared_error(test_y[cname], pdict[cname]))
    print("  r2_score: %s" % r2_score(test_y[cname], pdict[cname]))
    print("  intercept: {}".format(lr.intercept_))
    for idx, col_name in enumerate(train_df.columns):
      print("  coef for {}: {}".format(col_name, lr.coef_[idx]))

  xarr = [x for x in range(test_count)]
  for cn in ['wa-I', 'wa-C', 'ph', 'rs']:
    plot_it(test_y[cn], pdict[cn], cn, xarr, args.show, args.save)
  

def main(argv):
  parser = argparse.ArgumentParser()
  parser.add_argument('--train')
  parser.add_argument('--test')
  parser.add_argument('--train_pct', type=int, default=90)
  parser.add_argument('--notdom', type=int, default=0)
  parser.add_argument('--show', type=int, default=1)
  parser.add_argument('--save', type=int, default=0)
  parser.add_argument('--model', default='linear')
  parser.add_argument('--normalize', type=int, default=0)
  # Value for regularization
  parser.add_argument('--alpha', type=float, default=1.0)
  parser.add_argument('--augment', type=int, default=0)
  parser.add_argument('--combine', type=int, default=0)
  parser.add_argument('--max_runs', type=int, default=-1)

  args = parser.parse_args(argv)
  runit(args)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
