// normalize date for mismatch issues
normalizeDate = (date) => {
  const [y, m, d] = date.split('-').map(Number);
  return new Date(Date.UTC(y, m - 1, d));
};

module.exports={normalizeDate};