from libc.stdint cimport uint8_t


ctypedef float SkScalar

cdef extern from "core/SkGeometry.h":
    cdef struct SkConic:
        SkConic()
        void set(const SkPoint& p0, const SkPoint& p1, const SkPoint& p2, SkScalar w)
        int computeQuadPOW2(SkScalar tol)

cdef extern from "include/core/SkPathTypes.h":

    enum SkPathFillType:
        kWinding "SkPathFillType::kWinding",
        kEvenOdd "SkPathFillType::kEvenOdd",
        kInverseWinding "SkPathFillType::kInverseWinding",
        kInverseEvenOdd "SkPathFillType::kInverseEvenOdd"

    enum SkPathDirection:
        kCW "SkPathDirection::kCW"
        kCCW "SkPathDirection::kCCW"


cdef extern from "include/core/SkPath.h":

    cdef cppclass SkPoint:

        @staticmethod
        SkPoint Make(SkScalar x, SkScalar y)

        SkScalar x()
        SkScalar y()

        bint equals(SkScalar x, SkScalar y)

        bint operator==(const SkPoint& other)

        bint operator!=(const SkPoint& other)

    cdef cppclass SkPath:

        SkPath() except +
        SkPath(SkPath& path) except +

        bint operator==(const SkPath& other)

        bint operator!=(const SkPath& other)

        void moveTo(SkScalar x, SkScalar y)
        void moveTo(const SkPoint& p)

        void lineTo(SkScalar x, SkScalar y)
        void lineTo(const SkPoint& p)

        void cubicTo(
            SkScalar x1, SkScalar y1,
            SkScalar x2, SkScalar y2,
            SkScalar x3, SkScalar y3)
        void cubicTo(const SkPoint& p1, const SkPoint& p2, const SkPoint& p3)

        void quadTo(SkScalar x1, SkScalar y1, SkScalar x2, SkScalar y2)
        void quadTo(const SkPoint& p1, const SkPoint& p2)

        void conicTo(SkScalar x1, SkScalar y1, SkScalar x2, SkScalar y2,
                     SkScalar w)
        void conicTo(const SkPoint& p1, const SkPoint& p2, SkScalar w)

        void arcTo(SkScalar rx, SkScalar ry, SkScalar xAxisRotate, ArcSize largeArc,
                   SkPathDirection sweep, SkScalar x, SkScalar y)
        void arcTo(SkPoint& r, SkScalar xAxisRotate, ArcSize largeArc,
                   SkPathDirection sweep, SkPoint& xy)

        void close()

        void dump()

        void dumpHex()

        void reset()

        void rewind()

        void setFillType(SkPathFillType ft)
        SkPathFillType getFillType()

        # TODO also expose optional AddPathMode enum
        void addPath(const SkPath& src) except +

        bint isConvex()

        bint contains(SkScalar x, SkScalar y)

        const SkRect& getBounds()

        SkRect computeTightBounds()

        int countPoints()

        SkPoint getPoint(int index)

        int getPoints(SkPoint points[], int maximum)

        int countVerbs()

        bint isEmpty()

        int getVerbs(uint8_t verbs[], int maximum)

        bint getLastPt(SkPoint* lastPt)

        cppclass Iter:

            Iter() except +
            Iter(const SkPath& path, bint forceClose) except +

            Verb next(SkPoint pts[4])

            SkScalar conicWeight()

            bint isCloseLine()

            bint isClosedContour()

        cppclass RawIter:

            RawIter() except +
            RawIter(const SkPath& path) except +

            Verb next(SkPoint pts[4])

            Verb peek()

            SkScalar conicWeight()

        void transform(const SkMatrix& matrix, SkPath* dst) const


cdef extern from * namespace "SkPath":

    enum Verb:
        kMove_Verb,
        kLine_Verb,
        kQuad_Verb,
        kConic_Verb,
        kCubic_Verb,
        kClose_Verb,
        kDone_Verb

    cdef int ConvertConicToQuads(const SkPoint& p0, const SkPoint& p1,
                                 const SkPoint& p2, SkScalar w,
                                 SkPoint pts[], int pow2)

    enum ArcSize:
        kSmall_ArcSize
        kLarge_ArcSize


cdef extern from "include/core/SkRect.h":

    cdef cppclass SkRect:

        SkScalar left()
        SkScalar top()
        SkScalar right()
        SkScalar bottom()

        @staticmethod
        bint Intersects(const SkRect& a, const SkRect& b)


cdef extern from "include/core/SkScalar.h":

    cdef enum:
        SK_ScalarNearlyZero


cdef extern from "include/core/SkPaint.h":
    enum SkLineCap "SkPaint::Cap":
        kButt_Cap "SkPaint::Cap::kButt_Cap",
        kRound_Cap "SkPaint::Cap::kRound_Cap",
        kSquare_Cap "SkPaint::Cap::kSquare_Cap"

    enum SkLineJoin "SkPaint::Join":
        kMiter_Join "SkPaint::Join::kMiter_Join",
        kRound_Join "SkPaint::Join::kRound_Join",
        kBevel_Join "SkPaint::Join::kBevel_Join"


cdef extern from "include/core/SkStrokeRec.h":
    cdef cppclass SkStrokeRec:
        SkStrokeRec(InitStyle style)
        void setStrokeStyle(SkScalar width, bint strokeAndFill)
        void setStrokeParams(SkLineCap cap, SkLineJoin join, SkScalar miterLimit)
        bint applyToPath(SkPath* dst, const SkPath& src) const;


cdef extern from * namespace "SkStrokeRec":
    enum InitStyle:
        kHairline_InitStyle,
        kFill_InitStyle


cdef extern from "include/core/SkMatrix.h":
    cdef cppclass SkMatrix:
        SkMatrix() except +

        bint operator!= (const SkMatrix &a, const SkMatrix &b)
        bint operator== (const SkMatrix &a, const SkMatrix &b)

        SkScalar get(int index) const
        SkScalar getScaleX() const
        SkScalar getScaleY() const
        SkScalar getSkewX() const
        SkScalar getSkewY() const
        SkScalar getTranslateX() const
        SkScalar getTranslateY() const
        SkScalar getPerspX() const
        SkScalar getPerspY() const
        void get9(SkScalar buffer[9]) const

        SkMatrix& set(int index, SkScalar value)
        SkMatrix& setScaleX(SkScalar v)
        SkMatrix& setScaleY(SkScalar v)
        SkMatrix& setSkewX(SkScalar v)
        SkMatrix& setSkewY(SkScalar v)
        SkMatrix& setTranslateX(SkScalar v)
        SkMatrix& setTranslateY(SkScalar v)
        SkMatrix& setPerspX(SkScalar v)
        SkMatrix& setPerspY(SkScalar v)
        SkMatrix& setAll(SkScalar scaleX,
                         SkScalar skewX,
                         SkScalar transX,
                         SkScalar skewY,
                         SkScalar scaleY,
                         SkScalar transY,
                         SkScalar persp0,
                         SkScalar persp1,
                         SkScalar persp2)
        SkMatrix& set9(const SkScalar buffer[9])
        SkMatrix& setIdentity()
        SkMatrix& setTranslate(SkScalar dx, SkScalar dy)
        SkMatrix& setScale(SkScalar sx, SkScalar sy, SkScalar px, SkScalar py)
        SkMatrix& setRotate(SkScalar degrees, SkScalar px, SkScalar py)
        SkMatrix& setSkew(SkScalar kx, SkScalar ky, SkScalar px, SkScalar py)
        SkMatrix& setConcat(const SkMatrix &a, const SkMatrix &b)

        SkMatrix& preTranslate(SkScalar dx, SkScalar dy)
        SkMatrix& preScale(SkScalar sx, SkScalar sy, SkScalar px, SkScalar py)
        SkMatrix& preRotate(SkScalar degrees, SkScalar px, SkScalar py)
        SkMatrix& preSkew(SkScalar kx, SkScalar ky, SkScalar px, SkScalar py)
        SkMatrix& preConcat(const SkMatrix &other)

        SkMatrix& postTranslate(SkScalar dx, SkScalar dy)
        SkMatrix& postScale(SkScalar sx, SkScalar sy, SkScalar px, SkScalar py)
        SkMatrix& postRotate(SkScalar degrees, SkScalar px, SkScalar py)
        SkMatrix& postSkew(SkScalar kx, SkScalar ky, SkScalar px, SkScalar py)
        SkMatrix& postConcat(const SkMatrix &other)

        bint asAffine(SkScalar affine[6]) const
        SkMatrix& setAffine(const SkScalar affine[6])

        void mapPoints(SkPoint pts[], int count) const
        SkPoint mapXY(SkScalar x, SkScalar y) const

        bint isFinite() const
        bint invert(SkMatrix *inverse) const

        @staticmethod
        SkMatrix Concat(const SkMatrix& a, const SkMatrix& b)
