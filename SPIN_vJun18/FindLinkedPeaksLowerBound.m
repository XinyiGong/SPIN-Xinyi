function [lbindex] = FindLinkedPeaksLowerBound(locs, w, wr, zpindex)
% A region that start from peak # zpindex to peak # ubindex
% All peaks within the region are linked (meaning x upper bound of one peak is greater than x lower bound of the next peak)
            if zpindex == 1
                lbindex = zpindex;
            else
                linkflag = 1;
                for iv = 1:(zpindex-1)
                    if locs(zpindex-iv) + wr * w(zpindex-iv) < locs(zpindex-iv+1) - wr * w(zpindex-iv+1)
                        lbindex = zpindex-iv+1;
                        linkflag = 0;
                        break
                    end
                end
                if linkflag
                    lbindex = 1;
                end
            end