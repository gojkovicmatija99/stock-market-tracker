import { CursorArrowRaysIcon, Square2StackIcon, ArrowPathIcon } from '@heroicons/react/24/outline';
import { TimeInterval } from './Watchlist';

interface ToolbarProps {
  onIntervalChange: (interval: TimeInterval) => void;
  selectedInterval: TimeInterval;
  isLoading: boolean;
}

const INTERVALS: TimeInterval[] = [
  '1min',
  '5min',
  '15min',
  '30min',
  '45min',
  '1h',
  '2h',
  '4h',
  '1day',
  '1week',
  '1month'
];

const Toolbar = ({ onIntervalChange, selectedInterval, isLoading }: ToolbarProps) => {
  return (
    <div className="flex items-center h-10 px-4 bg-tradingview-panel border-b border-tradingview-border">
      <div className="flex items-center space-x-2">
        {INTERVALS.map((interval) => (
          <button
            key={interval}
            onClick={() => onIntervalChange(interval)}
            className={`px-3 py-1 text-sm text-tradingview-text hover:bg-tradingview-bg rounded flex items-center space-x-1 ${
              selectedInterval === interval ? 'bg-tradingview-bg' : ''
            }`}
          >
            <span>{interval}</span>
            {isLoading && selectedInterval === interval && (
              <ArrowPathIcon className="h-3 w-3 animate-spin" />
            )}
          </button>
        ))}
      </div>

      <div className="flex-1" />

      <div className="flex items-center space-x-2">
        <button className="p-2 hover:bg-tradingview-bg rounded">
          <CursorArrowRaysIcon className="h-4 w-4 text-tradingview-text" />
        </button>
        <button className="p-2 hover:bg-tradingview-bg rounded">
          <Square2StackIcon className="h-4 w-4 text-tradingview-text" />
        </button>
      </div>
    </div>
  );
};

export default Toolbar; 