  Hunk(..),
  truncatePatch
import Data.Bifunctor.Join
import Data.Functor.Both as Both
import Data.List (span, unzip)
import Data.String
import Data.Text (pack)
import Data.These
import Patch
import Prologue hiding (fst, snd)

-- | Render a timed out file as a truncated diff.
truncatePatch :: DiffArguments -> Both SourceBlob -> Text
truncatePatch _ blobs = pack $ header blobs ++ "#timed_out\nTruncating diff: timeout reached.\n"
patch :: Renderer
patch diff blobs = pack $ case getLast (foldMap (Last . Just) string) of
data Hunk a = Hunk { offset :: Both (Sum Int), changes :: [Change a], trailingContext :: [Join These a] }
data Change a = Change { context :: [Join These a], contents :: [Join These a] }
rowIncrement :: Join These a -> Both (Sum Int)
rowIncrement = Join . fromThese (Sum 0) (Sum 0) . runJoin . (Sum 1 <$)
  showLines (snd sources) ' ' (maybeSnd . runJoin <$> trailingContext hunk)
        (lengthA, lengthB) = runJoin . fmap getSum $ hunkLength hunk
        (offsetA, offsetB) = runJoin . fmap (show . getSum) $ offset hunk
showChange sources change = showLines (snd sources) ' ' (maybeSnd . runJoin <$> context change) ++ deleted ++ inserted
  where (deleted, inserted) = runJoin $ pure showLines <*> sources <*> both '-' '+' <*> Join (unzip (fromThese Nothing Nothing . runJoin . fmap Just <$> contents change))
showLines :: Source Char -> Char -> [Maybe (SplitDiff leaf Info)] -> String
showLine :: Source Char -> Maybe (SplitDiff leaf Info) -> Maybe String
showLine source line | Just line <- line = Just . toString . (`slice` source) $ getRange line
                     | otherwise = Nothing
        (pathA, pathB) = runJoin $ path <$> blobs
        (oidA, oidB) = runJoin $ oid <$> blobs
        (modeA, modeB) = runJoin $ blobKind <$> blobs

-- | A hunk representing no changes.
emptyHunk :: Hunk (SplitDiff a Info)
emptyHunk = Hunk { offset = mempty, changes = [], trailingContext = [] }
hunks :: Show a => Diff a Info -> Both SourceBlob -> [Hunk (SplitDiff a Info)]
  = [emptyHunk]
hunks diff blobs = hunksInRows (pure 1) $ alignDiff (source <$> blobs) diff
hunksInRows :: Both (Sum Int) -> [Join These (SplitDiff a Info)] -> [Hunk (SplitDiff a Info)]
nextHunk :: Both (Sum Int) -> [Join These (SplitDiff a Info)] -> Maybe (Hunk (SplitDiff a Info), [Join These (SplitDiff a Info)])
nextChange :: Both (Sum Int) -> [Join These (SplitDiff a Info)] -> Maybe (Both (Sum Int), Change (SplitDiff a Info), [Join These (SplitDiff a Info)])
changeIncludingContext :: [Join These (SplitDiff a Info)] -> [Join These (SplitDiff a Info)] -> Maybe (Change (SplitDiff a Info), [Join These (SplitDiff a Info)])
rowHasChanges :: Join These (SplitDiff a Info) -> Bool
rowHasChanges row = or (hasChanges <$> row)