function [ubindex] = FindLinkedPeaksUpperBound(locs, w, wr, zpindex)
% A region that start from peak # zpindex to peak # ubindex
% All peaks within the region are linked (meaning x upper bound of one peak is greater than x lower bound of the next peak)
            if zpindex == size(locs,2)
                ubindex = zpindex;
            else
                linkflag = 1;
                for iv = zpindex:(size(locs,2)-1)
                    if locs(iv) + wr * w(iv) < locs(iv+1) - wr * w(iv+1)
                        ubindex = iv;
                        linkflag = 0;
                        break
                    end
                end
                if linkflag
                    ubindex = size(locs,2);
                end
            end
            
end
