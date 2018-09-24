import argparse
import sys
import math
import numpy
import pandas as pd
from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score
import matplotlib.pyplot as plt

def print_df(t):
  for x, r in t.iterrows():
    print('%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s' % (
        r['L'], r['F'], r['wa-I'], r['wa-C'], r['sa'], r['ca'], r['Nruns'],
        r['ph'], r['pm'], r['rs'], r['rn'], r['isdom']))

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

def get_model(args):
  if args.model == 'linear':
    return linear_model.LinearRegression(normalize=args.normalize)
  elif args.model == 'ridge':
    return linear_model.Ridge(normalize=args.normalize, alpha=args.alpha)
  else:
    print('model not supported: %s' % args.model)
    sys.exit(-1)

def runit(args):
  t = pd.read_table(args.file)
  if args.notdom:
    t = t[ t['isdom'] == False ]

  count = t.count()['L']

  t2 = t.drop(['wa-I', 'wa-C', 'ph', 'pm', 'rs', 'rn', 'L', 'isdom'], axis=1)
  t2.F = t2.F.astype('category').cat.codes

  f1 = len(t2.columns)

  if args.augment:
    for c in t2.columns:
      if c not in ['F', 'isdom']:
        t2[c + '_sq'] = t2[c] * t2[c]
        t2[c + '_sqrt'] = numpy.sqrt(t2[c])
        t2[c + '_log'] = numpy.log2(t2[c])
  f2 = len(t2.columns)

  if args.combine:
    cols = [c for c in t2.columns if c != ['F', 'isdom']]
    for c1 in cols:
      for c2 in cols:
        t2[c1 + '_X_' + c2] = t2[c1] * t2[c2]
  f3 = len(t2.columns)

  print('features: %d initial, %d post agument, %d post combine' % (f1, f2, f3))

  y_wai = t['wa-I']
  y_wac = t['wa-C']
  y_ph = t['ph']
  y_rs = t['rs']

  pdict = {}
  for pv in [('wa-I', y_wai), ('wa-C', y_wac), ('ph', y_ph), ('rs', y_rs)]:
    lr = get_model(args)
    lr.fit(t2, pv[1])
    pdict[pv[0]] = lr.predict(t2)
    print(pv[0])
    print("  mean squared error: %s" % mean_squared_error(pv[1], pdict[pv[0]]))
    print("  variance score: %s" % r2_score(pv[1], pdict[pv[0]]))
    print("  intercept: {}".format(lr.intercept_))
    for idx, col_name in enumerate(t2.columns):
      print("  coef for {}: {}".format(col_name, lr.coef_[idx]))

  xarr = [x for x in range(count)]

  for v in [(y_wai, 'wa-I'), (y_wac, 'wa-C'), (y_ph, 'ph'), (y_rs, 'rs')]:
    plot_it(v[0], pdict[v[1]], v[1], xarr, args.show, args.save)
  

def main(argv):
  parser = argparse.ArgumentParser()
  parser.add_argument('--file')
  parser.add_argument('--notdom', type=int, default=0)
  parser.add_argument('--show', type=int, default=1)
  parser.add_argument('--save', type=int, default=0)
  parser.add_argument('--model', default='linear')
  parser.add_argument('--normalize', type=int, default=0)
  # Value for regularization
  parser.add_argument('--alpha', type=float, default=1.0)
  parser.add_argument('--augment', type=int, default=0)
  parser.add_argument('--combine', type=int, default=0)

  args = parser.parse_args(argv)
  runit(args)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
